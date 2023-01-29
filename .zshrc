#generic
LC_CTYPE=en_US.UTF-8
LC_ALL=en_US.UTF-8
LC_TIME=ru_RU.UTF-8

export TERM="xterm-256color"

export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.pub-cache/bin:$PATH

export EDITOR=$(which nvim &> /dev/zero && which nvim || which vi)
export VISUAL=$(which nvim &> /dev/zero && which nvim || which vi)


#zsh specific
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="tjkirch"
export UPDATE_ZSH_DAYS=7
COMPLETION_WAITING_DOTS="true"
ZSH_DISABLE_COMPFIX=true

plugins=(
	zsh-autosuggestions
	command-not-found
	autoupdate
	fzf-tab
	docker
	fzf
	ssh
	git
	sudo
)

source $ZSH/oh-my-zsh.sh

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
autoload -U compinit promptinit
compinit -C

HISTFILE=~/.zsh_history
HISTSIZE=9999999999
SAVEHIST=$HISTSIZE


#FZF preview
FZF_FLAGS='--multi --height=50% --preview-window=right:70%:wrap'
FZF_PREVIEW='less ${(Q)realpath}'

zstyle ':completion::complete:*' use-cache 1

zstyle ':fzf-tab:complete:(cat|vi|vim|nvim):argument-rest' fzf-preview $FZF_PREVIEW
zstyle ':fzf-tab:complete:*:argument-rest' fzf-flags $(echo $FZF_FLAGS)

zstyle ':fzf-tab:complete:(cd):*' fzf-preview $FZF_PREVIEW
zstyle ':fzf-tab:complete:(cd):*' fzf-flags $(echo $FZF_FLAGS)

zstyle ':fzf-tab:complete:(\\|*/|)man:*' fzf-preview 'man $word'
zstyle ':fzf-tab:complete:(\\|*/|)man:*' fzf-flags $(echo $FZF_FLAGS)

zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview 'echo ${(P)word}'

zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff $word | delta --line-numbers'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview 'git log --color=always $word'
zstyle ':fzf-tab:complete:git-help:*' fzf-preview 'git help $word | bat -plman --color=always'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
	'case "$group" in
	"commit tag") git show --color=always $word ;;
	*) git show --color=always $word | delta ;;
	esac'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
	'case "$group" in
	"modified file") git diff $word | delta ;;
	"recent commit object name") git show --color=always $word | delta ;;
	*) git log --color=always $word ;;
	esac'


#OS related settings
OS=$(uname -s)
case $OS in
  Darwin)
	[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

    export GPG_TTY=$(tty)

    export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:${PATH}"
    export MANPATH="/opt/homebrew/opt/coreutils/libexec/gnuman:${MANPATH}"

	FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
	FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

	eval "$(starship init zsh)"

	export PATH="/opt/homebrew/opt/unzip/bin:$PATH"
	export PATH=/opt/flutter/bin:$PATH
	export PATH=$HOME/Library/Application\ Support/JetBrains/Toolbox/scripts:$PATH
	export PATH=$HOME/Library/Android/sdk/platform-tools:$PATH
	;;

  Linux)
	if test -f /usr/share/autojump/autojump.zsh
	then
	    source /usr/share/autojump/autojump.zsh
	fi

	export PATH=/usr/lib/docker/cli-plugins:$PATH
    ;;

  *)
    echo "unknown operation system $OS"
    ;;
esac


#aliases
alias l='ls -lah --color=always --group-directories-first'

alias ty='echo "ur welcome"'
alias please='sudo'

alias :q='exit'
alias :q!='exit'
alias :wq='exit'
alias :wq!='exit'

alias claer='clear'

alias yolo='git commit -m "$(curl --silent --fail https://whatthecommit.com/index.txt)"'


#fancy
fortune | cowsay -d -p
