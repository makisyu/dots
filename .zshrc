autoload -U compinit
compinit

setopt magic_equal_subst
setopt prompt_subst

setopt auto_pushd
setopt correct
setopt list_packed

autoload colors
zstyle ':completion:*' list-colors "${LS_COLORS}"

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' max-exports 7
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' formats '%R' '%S' '%b' '%s' '%c' '%u'
zstyle ':vcs_info:*' actionformats '%R' '%S' '%b|%a' '%s' '%c' '%u'

function echo_rprompt () {
    local branch
    STY= LANG=en_US.UTF-8 vcs_info    
    if [[ -n "$vcs_info_msg_1_" ]]; then
        branch="$vcs_info_msg_2_"
        if [[ -n "$vcs_info_msg_4_" ]]; then
            branch="%F{green}(staged) $branch%f"
        elif [[ -n "$vcs_info_msg_5_" ]]; then
            branch="%F{red}(unstaged) $branch%f"
        else
            branch="%F{blue}$branch%f"
        fi
        print -n "$branch"
    fi
}

if [ "$(whoami)" = "root" ]; then
    CARETCOLOR="red"
else
    CARETCOLOR="magenta"
fi

local return_code="%(?..%B%F{red}:( %?%f%b)"
PROMPT='%F{cyan}%n%f%F{yellow}@%f%F{blue}%m%f:%F{green}%~%f %F{${CARETCOLOR}}%#%f '
RPROMPT='`echo_rprompt` ${return_code} %D - %*'

HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=$HISTSIZE

bindkey -e

export LESSOPEN='| src-hilite-lesspipe.sh %s'
export LESS=' -R '
export CSCOPE_EDITOR=vim

alias tig='tig --all'
