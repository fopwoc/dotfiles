#!/bin/bash


#define system
OS=$(uname -s)

case $OS in
  Darwin)
    #deps and cool utils on macos
    brew install exa ripgrep fd git-delta bat tealdeer zoxide starship fzf nvim fortune cowsay htop tmux httpie ncdu
    ;;

  Linux)
    distro=$(uname -v)

    #deps and utils for ubuntu
    if [[ $distro == *"Ubuntu"* ]]; then
      sudo apt -y install fzf vim fortune cowsay htop tmux ncdu pip libncurses5-dev
      sudo snap install rustup --classic && rustup update stable && cargo install exa fd-find ripgrep git-delta bat tealdeer zoxide starship
      pip install tldr httpie
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
  ln -s $(pwd)/.zshrc $HOME/.zshrc
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

#symlink wezterm
if [[ ! -L "$HOME/.config/wezterm/wezterm.lua" ]]; then
  echo "symlink wezterm"
  ln -fs $(pwd)/wezterm $HOME/.config/wezterm
fi

#symlink .lessfilter
if [[ ! -L "$HOME/.lessfilter" ]]; then
  echo "symlink lessfilter"
  ln -fs $(pwd)/.lessfilter $HOME/.lessfilter
fi

#symlink .starship.toml
if [[ ! -L "$HOME/.config/starship.toml" ]]; then
  echo "symlink starship.toml"
  ln -fs $(pwd)/starship.toml $HOME/.config/starship.toml
fi


#install fast-syntax-highlighting plugin for oh-my-zsh
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting" ]]; then
  git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
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
which nvim &> /dev/zero && ln -s $(which nvim) ~/.local/bin/vim

#update vim plugins
vim -E -s -u $HOME/.vimrc +PlugInstall +qall

#update tldr
tldr --update

#run zsh and build fzf color binary
exec /bin/zsh -c "source ~/.zshrc && build-fzf-tab-module && clear && reset && echo \"have a nice time!!!\""
