# fastlane-manual-match-cli
Simple CLI for manual match certificates and profiles.

## Usage

The CLI ONLY support `sync` feature at this time, and we can just type `ruby ./cli.rb sync` to start our upload process!

`sync` does fastlane match certificates and profiles upload by manually, help message shows below:

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

After passed the options, it will start sync process and we maybe see the outputs like below:

```
...
[16:25:10]: Cloning remote git repo...
[16:25:10]: If cloning the repo takes too long, you can use the `clone_branch_directly` option in match.
[16:25:13]: 🔓  Successfully decrypted certificates repo
[16:25:13]: 🔒  Successfully encrypted certificates repo
[16:25:13]: Pushing changes to remote git repo...
[16:25:14]: Successfully synced certs and profiles to remote repo
[16:25:14]: 🍺
```

As you seen, the certificates and profiles has been synced into remote match repo!
Enjoy!

## Warning

This cli will sync the selected certificates and profiles into remote repo at every time and maybe overwrite the original one, even you selected a wrong file!

Be carefully to type `sync`, until you exactly know what you are doing!

## Acknowledgments

Thanks [JCMais](https://github.com/JCMais)'s [blog post](https://medium.com/@jonathancardoso/using-fastlane-match-with-existing-certificates-without-revoking-them-a325be69dac6), and hope this cli frees you of heavy ios build jobs!
