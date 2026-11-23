if test -e /usr/share/cachyos-fish-config/conf.d/done.fish
    source /usr/share/cachyos-fish-config/conf.d/done.fish
end

set -U __done_min_cmd_duration 10000
set -U __done_notification_urgency_level low

# ========================
# Environment
# ========================
if command -vq nvim
    set -gx EDITOR nvim
else if command -vq vim
    set -gx EDITOR vim
else
    set -gx EDITOR vi
end

set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"

set -gx CARGO_HOME "$XDG_DATA_HOME/cargo"
set -gx RUSTUP_HOME "$XDG_DATA_HOME/rustup"

if command -vq bat
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
    set -gx MANROFFOPT -c
else
    set -gx MANPAGER "less -R"
end

# Work
set -gx JAVA_HOME /usr/lib/jvm/java-21-openjdk-amd64
fish_add_path $JAVA_HOME/bin

# ========================
# PATH
# ========================
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.local/bin/scripts
fish_add_path $HOME/.local/applications/dcm4che-5/bin
fish_add_path $XDG_DATA_HOME/cargo/bin

# ========================
# Flatpak
# ========================
if command -vq flatpak
    set -ga fish_user_paths ~/.local/share/flatpak/exports/bin /var/lib/flatpak/exports/bin
    set -gx --path XDG_DATA_DIRS /usr/local/share/ /usr/share/ ~/.local/share/flatpak/exports/share
    for install_dir in (flatpak --installations)
        set -gxa XDG_DATA_DIRS $install_dir/exports/share
    end
end

# ========================
# Abbreviations
# ========================
abbr mv "mv -iv"
abbr cp "cp -riv"
abbr mkdir "mkdir -vp"
abbr rm "rm -vI"
abbr free "free -m"
abbr df "df -h"
abbr sv "sudo $EDITOR"
abbr cs "cd ~/.local/sources && claude"  # Claude Code for support work

# ========================
# Aliases
# ========================
alias v="$EDITOR"
alias g="git"
alias s="kitten ssh"
alias jctl="journalctl -p 3 -xb"
alias tb="nc termbin.com 9999"

if command -vq eza
    alias ls="eza -Al --color=always --group-directories-first --icons=auto"
    alias ll="eza -lA --color=always --group-directories-first --icons=auto"
    alias lt="eza -aT --color=always --group-directories-first --icons=auto"
else
    alias ls="ls --color=auto"
    alias ll="ls -lA --color=auto"
    alias lt="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
end

# ========================
# Functions
# ========================
function fish_greeting
    fastfetch
end

function history
    builtin history --show-time='%F %T '
end

function backup --argument filename
    cp $filename $filename.bak
end

# ========================
# Keybindings
# ========================

# Set VI mode for the prompt indicator
fish_vi_key_bindings

function fish_user_key_bindings
    # Apply default (Emacs) bindings to the relevant modes
    for mode in default insert visual
        fish_default_key_bindings -M $mode
    end
    # Then apply vi bindings without erasing the ones above
    fish_vi_key_bindings --no-erase
end

# !! abbr last comand
function __history_previous_command
    switch (commandline -t)
        case "!"
            commandline -t $history[1]
            commandline -f repaint
        case "*"
            commandline -i !
    end
end

# !$ abbr last argument
function __history_previous_command_arguments
    switch (commandline -t)
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

if [ "$fish_key_bindings" = fish_vi_key_bindings ]
    bind -Minsert ! __history_previous_command
    bind -Minsert '$' __history_previous_command_arguments
else
    bind ! __history_previous_command
    bind '$' __history_previous_command_arguments
end

# ========================
# Integrations
# ========================

fzf --fish | source
zoxide init fish | source
