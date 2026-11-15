# dotfiles

Personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

## Install on a new machine

```sh
sh -c "$(curl -fsLS https://get.chezmoi.io/lb)" -- init --apply PerseweratywneImponderabilia
```

This installs `chezmoi` into `~/.local/bin`, clones this repo into
`~/.local/share/chezmoi` and writes the files into `$HOME`.

The applications some of these files point to (Mirth Connect Administrator
Launcher, Linphone, Oracle JDK 8, go-passbolt-cli, …) are not installed by
chezmoi. A separate bootstrap script, kept outside this repo, installs them
before running the command above.

## Everyday use

| Task | Command |
|---|---|
| Edit a managed file | `chezmoi edit ~/.config/fish/config.fish` |
| Start managing a file | `chezmoi add <file>` |
| See what would change | `chezmoi diff` / `chezmoi status` |
| Write the repo state to `$HOME` | `chezmoi apply` |
| Pull and apply changes from GitHub | `chezmoi update` |
| Commit and push | `chezmoi cd`, then `git commit` / `git push` |

topgrade is configured **not** to run chezmoi (see `.config/topgrade.toml`),
so pull changes with `chezmoi update`.

## What's in here

| Path | Purpose |
|---|---|
| `.bashrc`, `.profile` | Bash and login-shell setup |
| `.config/fish/config.fish` | Main shell: XDG variables, `PATH` (`~/.local/bin`, `~/.local/bin/scripts`), `JAVA_HOME`, abbreviations and aliases |
| `.config/kitty/` | kitty terminal and theme. `ssh.conf` makes `kitten ssh` (alias `s`) copy the files from `remote-configs` to the remote host |
| `.config/remote-configs/` | Minimal `.bashrc`, `.inputrc` and `.vimrc` used on remote servers |
| `.config/niri/` | Niri compositor. `dms/` holds DankMaterialShell includes; `empty_` source files are written as empty files |
| `.config/paru/paru.conf` | AUR helper settings (Arch-based machines only) |
| `.config/topgrade.toml` | topgrade: steps that are disabled |
| `.config/mimeapps.list` | Default applications |
| `.java/deployment/security/exception.sites` | Java Web Start exception list needed by `exhibeon` |
| `.local/bin/scripts/archive` | Extract or create archives; guesses the mode from its arguments |
| `.local/bin/scripts/pbpass` | Find a Passbolt password by title and print or copy it (needs `go-passbolt-cli`) |
| `.local/bin/scripts/exhibeon` | Launch Exhibeon (Java Web Start) against a chosen server (needs Oracle JDK 8 in `/usr/lib/jvm/jdk1.8.0_202`) |
| `.local/bin/scripts/printerwsparcie` | Set up a shared office printer through CUPS |
| `.local/share/applications/` | Menu entries for Mirth Connect Administrator (`mirth-launcher`) and Linphone (`linphone`) |
| `.local/share/icons/` | Icons for those menu entries |

## Conventions

- **File modes:** `.chezmoi.toml.tmpl` pins `umask = 0o002`, so managed files
  are written as 664 (775 if executable) and directories as 775, whatever umask
  chezmoi is started with. After changing the template, run `chezmoi init` to
  regenerate `~/.config/chezmoi/chezmoi.toml`.
- **Executables** are stored with the `executable_` prefix
  (`chezmoi add` sets it automatically for executable files).
- **No secrets.** This repo is public: keep passwords, tokens and keys in
  Passbolt and read them at runtime (for example with `pbpass`).
- `README.md` itself is listed in `.chezmoiignore`, so it is not copied into `$HOME`.
