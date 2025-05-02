### ADDING TO THE PATH
# First line removes the path; second line sets it.  Without the first line,
# your path gets massive and fish becomes very slow.
set -e fish_user_paths
set -U fish_user_paths $HOME/.local/bin $HOME/.cargo/bin $fish_user_paths

# set -gx LIBCLANG_PATH "$HOME/.rustup/toolchains/esp/xtensa-esp32-elf-clang/esp-16.0.4-20231113/esp-clang/lib"
# set -gx PATH "$HOME/.rustup/toolchains/esp/xtensa-esp-elf/esp-13.2.0_20230928/xtensa-esp-elf/bin:$PATH"

### EXPORT ###
set fish_greeting
set TERM xterm-256color
set -gx OPENER      "/usr/bin/xdg-open"
set -gx READER      "/usr/bin/zathura"
set -gx BROWSER     "/usr/bin/brave"
set -gx VIDEO       "/usr/bin/mpv"
set -gx IMAGE       "/usr/bin/feh"
set -gx TERMINAL    "$HOME/.local/bin/alacritty"
set -gx EDITOR      "$HOME/Application/nvim.appimage"
set -gx VISUAL      "$HOME/Application/neovide.AppImage"
set -gx COLORTERM truecolor

# set -gx QT_STYLE_OVERRIDE gtk2
set -gx GTK_USE_PORTAL 1
# set -gx USERNAME_GITHUB "RizalAchp"

set -gx --path XDG_DESKTOP_DIR     "$HOME/Desktop"
set -gx --path XDG_DOCUMENTS_DIR   "$HOME/Documents"
set -gx --path XDG_DOWNLOAD_DIR    "$HOME/Downloads"
set -gx --path XDG_MUSIC_DIR       "$HOME/Music"
set -gx --path XDG_PICTURES_DIR    "$HOME/Pictures"
set -gx --path XDG_PUBLICSHARE_DIR "$HOME/Public"
set -gx --path XDG_TEMPLATES_DIR   "$HOME/Templates"
set -gx --path XDG_VIDEOS_DIR      "$HOME/Videos"

set -gx --path XDG_CONFIG_HOME     "$HOME/.config"
set -gx --path XDG_CACHE_HOME      "$HOME/.cache"
set -gx --path XDG_DATA_HOME       "$HOME/.local/share"
set -gx --path XDG_STATE_HOME      "$HOME/.local/state"

set -l xdg_data_home $XDG_DATA_HOME ~/.local/share
set -gx --path XDG_DATA_DIRS $xdg_data_home[1]/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share

for flatpakdir in ~/.local/share/flatpak/exports/bin /var/lib/flatpak/exports/bin
    if test -d $flatpakdir
        contains $flatpakdir $PATH; or set -a PATH $flatpakdir
    end
end
