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

# ========================
# PATH
# ========================
fish_add_path $XDG_DATA_HOME/cargo/bin
fish_add_path $HOME/.local/bin

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

# ========================
# Aliases
# ========================
alias v="$EDITOR"
alias g="git"
alias s="kitten ssh"
alias dps="docker ps"
alias dpsa="docker ps -a"
alias dlog="docker logs -f --tail 333"
alias tlog="tail -Fn333"
alias jctl="journalctl -p 3 -xb"
alias psmem="ps auxf | sort -nr -k 4"
alias tb="nc termbin.com 9999"
alias tarnow="tar -acf"
alias untar="tar -zxvf"
alias bgcustom="printf '\033]11;#1a1a1a\007'"
alias bgdefault="printf '\033]11;#000000\007'"

if command -vq eza
    alias ls="eza -Al --color=always --group-directories-first --icons"
    alias ll="eza -lA --color=always --group-directories-first --icons"
    alias lt="eza -aT --color=always --group-directories-first --icons"
else
    alias ls="ls --color=auto --group-directories-first"
    alias ll="ls -lA --color=auto --group-directories-first"
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
function __history_previous_command
    switch (commandline -t)
        case "!"
            commandline -t $history[1]
            commandline -f repaint
        case "*"
            commandline -i !
    end
end

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

# Fix airpods being recognized as a headset
#function reconnect-airpods
#    bluetoothctl disconnect 28:2D:7F:DC:67:DD
#    sleep 1
#    bluetoothctl connect 28:2D:7F:DC:67:DD
#    sleep 2
#    systemctl --user restart wireplumber pipewire pipewire-pulse
#    sleep 3

#    # Retry setting profile multiple times
#    for i in (seq 1 5)
#        if pactl set-card-profile bluez_card.28_2D_7F_DC_67_DD a2dp-sink
#            echo "Successfully set A2DP profile"
#            sleep 1
#            pactl set-default-sink bluez_output.28_2D_7F_DC_67_DD.1
#            echo "Set as default sink"
#            return 0
#        end
#        echo "Attempt $i failed, retrying in 1 second..."
#        sleep 1
#    end

#    echo "Failed to set A2DP profile after 5 attempts"
#end
