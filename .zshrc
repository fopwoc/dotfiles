ZSH_DISABLE_COMPFIX=true

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="tjkirch"

# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=1
ZSH_CUSTOM_AUTOUPDATE_QUIET=true

# Uncomment the following line to enable command auto-correction.
#ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
COMPLETION_WAITING_DOTS="true"

plugins=(
fast-syntax-highlighting
zsh-autosuggestions
command-not-found
autoupdate
autojump
fzf-tab
docker
fzf
ssh
git
sudo
)

source $ZSH/oh-my-zsh.sh
export LANG=ru_RU.UTF-8

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
autoload -U compinit promptinit
compinit -C

zstyle ':completion::complete:*' use-cache 1
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
	'git diff $word | delta'|
zstyle ':fzf-tab:complete:git-log:*' fzf-preview \
	'git log --color=always $word'
zstyle ':fzf-tab:complete:git-help:*' fzf-preview \
	'git help $word | bat -plman --color=always'
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

zstyle ':fzf-tab:complete:*:*' fzf-preview 'less ${(Q)realpath}'
export LESSOPEN='|~/.lessfilter %s'

HISTFILE=~/.zsh_history
HISTSIZE=999999999
SAVEHIST=$HISTSIZE

alias ls='exa'
alias l='exa -la --group-directories-first'
alias lg='l --git'
alias lt='l --tree --level 2'
alias lst='exa --tree --level 2'
alias ll='exa -lbGF --git'
alias llm='exa -lbGd --git --sort=modified'
alias lx='exa -lbhHigUmuSa@ --time-style=long-iso --git --color-scale'

alias ty='echo "ur welcome"'
alias please='sudo'

alias yolo='git commit -m "$(curl -s http://whatthecommit.com/index.txt)"'

export CHROME_EXECUTABLE=/usr/bin/google-chrome

export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH

export PATH=/opt/android-studio/bin:$PATH
export PATH=/opt/flutter/bin:$PATH
export PATH=/opt/jdk/bin:$PATH
export PATH=/opt/jetbrains-toolbox/:$PATH

export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/vim
#export NODE_OPTIONS=--openssl-legacy-provider

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

fortune | cowsay -d -p
