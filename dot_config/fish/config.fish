source /usr/share/cachyos-fish-config/cachyos-config.fish

set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"

fish_add_path $XDG_DATA_HOME/cargo/bin
fish_add_path $HOME/.local/bin

set -gx EDITOR nvim
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"

# Fix flatpak apps not being recognized
if command -vq flatpak
    set -ga fish_user_paths ~/.local/share/flatpak/exports/bin /var/lib/flatpak/exports/bin
    set -gx --path XDG_DATA_DIRS /usr/local/share/ /usr/share/ ~/.local/share/flatpak/exports/share
    for install_dir in (flatpak --installations)
        set -gxa XDG_DATA_DIRS $install_dir/exports/share
    end
end

# Verbosity and settings that you pretty much just always are going to want.
abbr mv "mv -iv"
abbr cp "cp -riv"
abbr mkdir "mkdir -vp"
abbr rm "rm -vI"
abbr free "free -m"
abbr df "df -h"
abbr sv "sudo nvim"
alias v="nvim"
alias g="git"

fnm env --use-on-cd --shell fish | source
fnm completions --shell fish | source

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

fish_config theme choose Matugen

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /home/shaggy/.lmstudio/bin
# End of LM Studio CLI section

# Fix airpods being recognized as a headset
function reconnect-airpods
    bluetoothctl disconnect 28:2D:7F:DC:67:DD
    sleep 1
    bluetoothctl connect 28:2D:7F:DC:67:DD
    sleep 2
    systemctl --user restart wireplumber pipewire pipewire-pulse
    sleep 3

    # Retry setting profile multiple times
    for i in (seq 1 5)
        if pactl set-card-profile bluez_card.28_2D_7F_DC_67_DD a2dp-sink
            echo "Successfully set A2DP profile"
            sleep 1
            pactl set-default-sink bluez_output.28_2D_7F_DC_67_DD.1
            echo "Set as default sink"
            return 0
        end
        echo "Attempt $i failed, retrying in 1 second..."
        sleep 1
    end

    echo "Failed to set A2DP profile after 5 attempts"
end
