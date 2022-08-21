#!/bin/bash
set -x

#define system
OS=$(uname -s)

case $OS in
  Darwin)
    #deps and cool utils on macos
    echo "ughh... lite config on mac????"
    exit 1
    ;;

  Linux)
    distro=$(uname -v)

    #deps and utils for ubuntu
    if [[ $distro == *"Ubuntu"* ]]; then
      sudo apt -y install fzf vim fortune cowsay htop tmux ncdu libncurses5-dev
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && rustup update stable && cargo install exa fd-find ripgrep zoxide
    else
      echo "Unknown distro! I cant install deps and utils..."
    fi
    ;;

  *)
    echo "unknown operation system $OS"
    exit 1
    ;;
esac

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

#symlink nvimrc
if [[ ! -L "$HOME/.config/nvim/init.vim" ]]; then
  echo "symlink nvim"
  ln -fs $(pwd)/nvim $HOME/.config/nvim
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

#symlink nvim exec
which nvim &> /dev/null && ln -s $(which nvim) ~/.local/bin/vim
which wezterm &> /dev/null && ln -s $(which wezterm) ~/.local/bin/gnome-terminal

#update vim plugins
vim -E -s -u $HOME/.vimrc +PlugInstall +qall

#run zsh and build fzf color binary
exec /bin/zsh -c "source ~/.zshrc && clear && reset && echo \"have a nice time!!!\""
