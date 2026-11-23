# dotfiles

Personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

## Install on a new machine

```sh
sh -c "$(curl -fsLS https://get.chezmoi.io/lb)" -- init --apply PerseweratywneImponderabilia
```

This installs `chezmoi` into `~/.local/bin`, clones this repo into
`~/.local/share/chezmoi` and writes the files into `$HOME`. It asks once for
your SSH login on the work servers (see `.ssh/config` below).

The applications some of these files point to are not installed by
chezmoi. The `bootstrap` script from the work-utilities repo installs them
before running the command above.

## Shell and terminal

- **Terminal: kitty**, the bootstrap `kitty` step installs and updates it.
- **`$SHELL` is bash.** The login shell is not changed with `chsh`, so
  `.profile` sets up the session (XDG variables, `PATH`) and anything that runs
  `$SHELL` gets bash.
- **kitty starts fish** (`shell fish` in `kitty.conf`). fish is the
  interactive shell you work in; type `bash` when you need bash.
- **zoxide** handles quick navigation, in both fish and bash: `z sources`
  jumps to the most-used directory matching "sources" (e.g. `~/.local/sources`),
  and `zi` lets you pick one with fzf.

## What's in here

| Path | Purpose |
|---|---|
| `.profile` | Login-shell setup for the whole session: XDG variables and `PATH` (every directory under `~/.local/bin`) |
| `.bashrc` | Interactive bash: history, prompt, fzf and zoxide |
| `.config/fish/config.fish` | Interactive fish (started by kitty): `EDITOR`, `JAVA_HOME`, abbreviations, aliases, vi key bindings, fzf and zoxide |
| `.config/kitty/` | kitty terminal and theme. `ssh.conf` makes `kitten ssh` (alias `s`) copy the files from `remote-configs` to the remote host |
| `.ssh/config` | `Host *` defaults for the work servers (`TERM`, the old `ssh-rsa` algorithms); `User` comes from your `sshUser` |
| `.config/remote-configs/` | Minimal `.bashrc`, `.inputrc` and `.vimrc` used on remote servers |
| `.config/niri/` | Niri compositor. `dms/` holds DankMaterialShell includes; `empty_` source files are written as empty files |
| `.config/paru/paru.conf` | AUR helper settings (Arch-based machines only) |
| `.config/topgrade.toml` | topgrade: steps that are disabled |
| `.config/mimeapps.list` | Default applications |
| `.java/deployment/security/exception.sites` | Java Web Start exception list needed by `exhibeon` (from work-utilities) |
| `.local/bin/scripts/archive` | Extract or create archives; guesses the mode from its arguments |
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
  Passbolt and read them at runtime (for example with `pbpass` from work-utilities).
- **Per-person values** go in `[data]` of `.chezmoi.toml.tmpl` with
  `promptStringOnce`: chezmoi asks on the first `chezmoi init` and keeps the
  answer in `~/.config/chezmoi/chezmoi.toml`. `sshUser` is the login written to
  `~/.ssh/config` as `User` (empty: no `User` line). To change it, edit
  `sshUser` there and run `chezmoi apply`. Templates read it with
  `index . "sshUser"`, so a machine that hasn't re-run `chezmoi init` still
  renders.
- **`~/.ssh/config` is replaced without asking**, also when you wrote it by
  hand. On a machine that already has one: `chezmoi init` (asks for the
  login), `chezmoi diff ~/.ssh/config`, copy anything you want to keep, then
  `chezmoi apply`. Hosts of your own can't stay in that file; they belong in
  the template or, if private, an `Include`d file outside the repo.
- `README.md` itself is listed in `.chezmoiignore`, so it is not copied into `$HOME`.
