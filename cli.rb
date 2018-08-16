# coding=utf-8

require 'spaceship'
require 'match'
require 'fastlane_core/helper'
require 'commander'
require 'fileutils'

UI = FastlaneCore::UI

MANUAL_MATCH_MANAGER_VERSION = '0.0.1'

ENV_FASTLANE_USERNAME = 'FASTLANE_USERNAME'
ENV_FASTLANE_PASSWORD = 'FASTLANE_PASSWORD'
ENV_MATCH_GIT_URL = 'MATCH_GIT_URL'
ENV_MATCH_GIT_PHASE = 'MATCH_GIT_PHASE'
ENV_MATCH_TYPE = 'MATCH_TYPE'
ENV_MATCH_CERT_PATH = 'MATCH_CERT_PATH'
ENV_MATCH_CERT_P12_PATH = 'MATCH_CERT_P12_PATH'
ENV_MATCH_PROFILE_PATH = 'MATCH_PROFILE_PATH'

MATCH_CERTIFICATES_DEVELOPMENT = 'certs/development'
MATCH_CERTIFICATES_DISTRIBUTION = 'certs/distribution'
MATCH_PROFILES_DEVELOPMENT = 'profiles/development'
MATCH_PROFILES_ADHOC = 'profiles/adhoc'
MATCH_PROFILES_APPSTORE = 'profiles/appstore'

MATCH_COMMIT_CHANGE_MESSAGE = 'Add/update certificate, private key and provisioning profiles'

module ManualMatchManager
    class CLI
        include Commander::Methods

        # Parses cli options and do sth
        def run
            program :name, 'ManualMatchManager'
            program :version, MANUAL_MATCH_MANAGER_VERSION
            program :description, 'easy fastlane manual match manager(CLI)'

            # Command to sync certificates and profiles to match git repo
            command :sync do |c|
                c.syntax = 'fastlane-manual-match-cli sync'
                c.description = 'sync specified certificates and profiles to match git repo.'

                c.option('--giturl giturl', String, 'remote match certificates git url for ssh')
                c.option('--gitphase gitphase', String, 'remote match certificates git repo phase')
                c.option('--matchtype matchtype', String, 'match type for the syncing certificates and profiles, e.g. development')
                c.option('--certpath certpath', String, 'absolute path for the certificates that you want to sync')
                c.option('--certp12path certp12path', String, 'absolute path for the certificates private key(p12) file that you want to sync')
                c.option('--profilepath profilepath', String, 'absolute path for the certificates private key(p12) file that you want to sync')

                c.action do |args, options|
                    git_url = options.giturl || ENV[ENV_MATCH_GIT_URL] || ask('Match GitUrl: ')
                    git_phase = options.gitphase || ENV[ENV_MATCH_GIT_PHASE] || ask('Match Gitphase: ') { |q| q.echo = '*' }
                    match_type = options.matchtype || ENV[ENV_MATCH_TYPE] || ask('Match Type: ')
                    cert_path = options.certpath || ENV[ENV_MATCH_CERT_PATH] || ask('Cert Path(absolute): ')
                    cert_p12_path = options.certp12path || ENV[ENV_MATCH_CERT_P12_PATH] || ask('Cert Private key(p12) Path(absolute): ')
                    profile_path = options.profilepath || ENV[ENV_MATCH_PROFILE_PATH] || ask('Match Profile Path(absolute): ')

                    sync(git_url, git_phase, match_type, cert_path, cert_p12_path, profile_path)
                    UI.success('Successfully synced certs and profiles to remote repo')
                    UI.success('🍺')
                end
            end

            run!
        end

        private

        # Sync certificates and profiles using fastlane libs
        def sync(git_url, git_phase, match_type, cert_path, cert_p12_path, profile_path)
            Spaceship.login
            workspace = Match::GitHelper.clone(git_url, shallow_clone: false, manual_password: git_phase)

            profile = File.basename(profile_path)

            # no match abort
            if (profile =~ /^(Development|AppStore|AdHoc)\_.+\.mobileprovision$/).nil? then
                UI.error('Invalid profile path, must be `<MATCH_TYPE>_<APPID>.mobileprovision`')
                exit 1
            end

            dst_certs_path = ''
            dst_profiles_path = ''
            case match_type
            when 'development'
                dst_certs_path = File.join(workspace, MATCH_CERTIFICATES_DEVELOPMENT)
                dst_profiles_path = File.join(workspace, MATCH_PROFILES_DEVELOPMENT)
            when 'adhoc'
                dst_certs_path = File.join(workspace, MATCH_CERTIFICATES_DISTRIBUTION)
                dst_profiles_path = File.join(workspace, MATCH_PROFILES_ADHOC)
            when 'appstore'
                dst_certs_path = File.join(workspace, MATCH_CERTIFICATES_DISTRIBUTION)
                dst_profiles_path = File.join(workspace, MATCH_PROFILES_APPSTORE)
            else
                UI.error('Unexpected match type!')
                exit 1
            end

            if dst_certs_path == '' || dst_profiles_path == '' then
                UI.error('Invalid cert path or profile path!')
                exit 1
            end

            # copy files to workspace
            FileUtils.cp_r(cert_path, dst_certs_path)
            FileUtils.cp_r(cert_p12_path, dst_certs_path)
            FileUtils.cp_r(profile_path, dst_profiles_path)

            # commit changes
            Match::GitHelper.commit_changes(workspace, MATCH_COMMIT_CHANGE_MESSAGE, git_url)
        end
    end
end

class MAIN
    include ManualMatchManager
    def main
        cli = CLI.new
        cli.run
    end
end

if __FILE__ == $PROGRAM_NAME
    main = MAIN.new
    main.main
end
