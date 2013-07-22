# Created by newuser for 4.3.10
autoload -U compinit
compinit

setopt magic_equal_subst
setopt prompt_subst

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git

# 下のformatsの値をそれぞれの変数に入れてくれる機能の、変数の数の最大。
# デフォルトだと2くらいなので、指定しておかないと、下のformatsがほぼ動かない。
zstyle ':vcs_info:*' max-exports 7
# 左から順番に、vcs_info_msg_{n}_ という名前の変数に格納されるので、下で利用する
# 状態が特殊な場合のformats
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
PROMPT='%B%F{cyan}%n%f%b%F{yellow}@%f%B%F{blue}%m%f%b:%B%F{green}%~%f%b %F{${CARETCOLOR}}%#%f '
RPROMPT='`echo_rprompt` ${return_code} %D - %*'

HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=$HISTSIZE

bindkey -e

export LESSOPEN="| src-hilite-lesspipe.sh %s"
export LESS=' -R '
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
alias tig='tig --all'
alias python='python3'

