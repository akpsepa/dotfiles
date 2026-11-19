
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/ameer/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/ameer/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/ameer/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/ameer/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup

alias gs="git status"


export PATH="$HOME/.local/bin:$PATH"
