#generic
export LANG=en_US.UTF-8
export LANGUAGE=${LANG}
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_TIME=ru_RU.UTF-8

export TERM="xterm-256color"

export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.pub-cache/bin:$PATH

export EDITOR=$(which nvim &> /dev/zero && which nvim || which vi)
export VISUAL=$(which nvim &> /dev/zero && which nvim || which vi)

export _ZO_ECHO=1
export LESSOPEN='|~/.lessfilter %s'


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

eval "$(zoxide init zsh --cmd j --hook prompt)"

HISTFILE=~/.zsh_history
HISTSIZE=999999999
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
	[[ -f $HOME/.dart-cli-completion/zsh-config.zsh ]] && . $HOME/.dart-cli-completion/zsh-config.zsh || true

	export GPG_TTY=$(tty)

    export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:${PATH}"
    export MANPATH="/opt/homebrew/opt/coreutils/libexec/gnuman:${MANPATH}"

	FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
	FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

	eval "$(starship init zsh)"

	export PATH="/opt/homebrew/opt/unzip/bin:$PATH"
	export PATH=$HOME/Library/Application\ Support/JetBrains/Toolbox/scripts:$PATH
	export PATH=$HOME/Library/Android/sdk/platform-tools:$PATH

	export JAVA_HOME=$(/usr/libexec/java_home)
	;;

  Linux)
	export PATH=/usr/lib/docker/cli-plugins:$PATH
    ;;

  *)
    echo "unknown operation system $OS"
    ;;
esac


#aliases
alias ls='exa'
alias l='exa -la --group-directories-first'
alias lg='l --git'
alias lt='l --tree --level 2'
alias lst='exa --tree --level 2'
alias ll='exa -lbGF --git'
alias llm='exa -lbGd --git --sort=modified'
alias lx='exa -lbhHigUmuSa@ --time-style=long-iso --git --color-scale'

alias :q='exit'
alias :q!='exit'
alias :wq='exit'
alias :wq!='exit'

alias claer='clear'

alias dart='fvm dart'
alias flutter='fvm flutter'
