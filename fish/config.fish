#      ___                        ___           ___           ___
#     /  /\           ___        /__/\         /  /\         /  /\
#    /  /::\         /__/\       \  \:\       /  /::\       /  /:/
#   /  /:/\:\        \__\:\       \  \:\     /  /:/\:\     /  /:/
#  /  /::\ \:\       /  /::\       \  \:\   /  /::\ \:\   /  /:/
# /__/:/\:\_\:\   __/  /:/\/  ______\__\:\ /__/:/\:\_\:\ /__/:/
# \__\/~|::\/:/  /__/\/:/~~  \  \::::::::/ \__\/  \:\/:/ \  \:\
#    |  |:|::/   \  \::/      \  \:\~~~~~       \__\::/   \  \:\
#    |  |:|\/     \  \:\       \  \:\           /  /:/     \  \:\
#    |__|:|~       \__\/        \  \:\         /__/:/       \  \:\
#     \__\|                      \__\/         \__\/         \__\/
#
# My fish config. Not much to see here; just some pretty standard stuff.

source ~/.config/fish/aliases.fish
source ~/.config/fish/path.fish
source ~/.config/fish/function.fish

### SET EITHER DEFAULT EMACS MODE OR VI MODE ###
function fish_user_key_bindings
    fish_default_key_bindings
end
### END OF VI MODE ###
zoxide init fish | source

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/rizal/miniconda3/bin/conda
    eval /home/rizal/miniconda3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/home/rizal/miniconda3/etc/fish/conf.d/conda.fish"
        . "/home/rizal/miniconda3/etc/fish/conf.d/conda.fish"
    end
end
# <<< conda initialize <<<

