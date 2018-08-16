# fastlane-manual-match-cli
Simple CLI for manual match certificates and profiles.

## Usage

> ruby ./cli.rb sync

We can use `sync` do fastlane match certificates and profiles upload by manually, help message shows below:

```
NAME:

  sync

SYNOPSIS:

  fastlane-manual-match-cli sync

DESCRIPTION:

  sync specified certificates and profiles to match git repo.

OPTIONS:

  --giturl giturl
      remote match certificates git url for ssh

  --gitphase gitphase
      remote match certificates git repo phase

  --matchtype matchtype
      match type for the syncing certificates and profiles, e.g. development

  --certpath certpath
      absolute path for the certificates that you want to sync

  --certp12path certp12path
      absolute path for the certificates private key(p12) file that you want to sync

  --profilepath profilepath
      absolute path for the certificates private key(p12) file that you want to sync
```

BTW, we can pass these options via `--xxx`, on-demand input, or environment variables.
There are some builtin env for this cli:

```
export FASTLANE_USERNAME="Input fastlane username here."
export FASTLANE_PASSWORD="Input fastlane password here."
export MATCH_GIT_URL="Input fastlane match certificates repo git url(ssh) here."
export MATCH_GIT_PHASE="Input fastlane match certificates repo git phase here."
export MATCH_TYPE="Input fastlane match type for the syncing certificates and profiles here."
export MATCH_CERT_PATH="Input syncing fastlane certificate absolute file path here."
export MATCH_CERT_P12_PATH="Input syncing fastlane cert private key(p12) absolute file path here."
export MATCH_PROFILE_PATH="Input syncing fastlane profile absolute file path here."
```

Enjoy!
