#!/bin/bash
set -x

#install oh-my-zsh
if [[ ! -d "$HOME/.oh-my-zsh/" ]]; then
  RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --keep-zshrc
fi

#symlink zshrc
if [[ ! -L "$HOME/.zshrc" ]]; then
  echo "symlink zshrc"
  mv $HOME/.zshrc $HOME/.zshrc.bak
  ln -s $(pwd)/.zshrc_lite $HOME/.zshrc
fi

#symlink vimrc
if [[ ! -L "$HOME/.vimrc" ]]; then
  echo "symlink vimrc"
  mv $HOME/.vimrc $HOME/.vimrc.bak
  ln -s $(pwd)/.vimrc $HOME/.vimrc
fi

#symlink tmux.conf
if [[ ! -L "$HOME/.tmux.conf" ]]; then
  echo "symlink tmux"
  ln -fs $(pwd)/.tmux.conf $HOME/.tmux.conf
fi


#install zsh-autosuggestions plugin for oh-my-zsh
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

#install autoupdate plugin for oh-my-zsh
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/autoupdate" ]]; then
git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/autoupdate
fi

#install fzf-tab plugin for oh-my-zsh
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-tab" ]]; then
  git clone https://github.com/Aloxaf/fzf-tab.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-tab
fi

#install ssh plugin for oh-my-zsh
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/ssh" ]]; then
  git clone https://github.com/zpm-zsh/ssh.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/ssh
fi

#install vim plug
if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]]; then
  curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

#update vim plugins
vim -E -s -u $HOME/.vimrc +PlugInstall +qall

exit 0
