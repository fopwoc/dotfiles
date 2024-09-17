#!/bin/bash

# replace_with_symlink <path_to_original_file> <path_to_symlink>
# 
# Arguments:
#   <path_to_original_file> - The path to the original file that you want to create a symlink to.
#   <path_to_symlink> - The path where the symlink should be created.
replace_with_symlink() {
    # Check if both arguments are provided
    if [[ $# -ne 2 ]]; then
        echo "Usage: $0 <path_to_original_file> <path_to_symlink>"
        return 1
    fi

    original_file=$1
    symlink_path=$2

    # Resolve relative paths
    original_file=$(realpath "$original_file")
    symlink_dir=$(dirname "$symlink_path")
    symlink_file=$(basename "$symlink_path")

    # Check if the original file exists
    if [[ ! -f "$original_file" ]]; then
        echo "Error: Original file '$original_file' does not exist."
        return 1
    fi

    # Create directory for the symlink if it does not exist
    if [[ ! -d "$symlink_dir" ]]; then
        mkdir -p "$symlink_dir"
    fi

    # If the symlink path already exists
    if [[ -e "$symlink_path" ]]; then
        if [[ -L "$symlink_path" ]]; then
            # It's a symlink, check if it points to the correct file
            current_target=$(readlink "$symlink_path")
            if [[ "$current_target" == "$original_file" ]]; then
                echo "Symlink is already correct. No action needed."
                return 0
            else
                echo "Replacing incorrect symlink with correct one."
                rm "$symlink_path"
            fi
        else
            # It's a regular file, rename it
            echo "File '$symlink_path' exists and is not a symlink. Renaming it to '$symlink_file.bak'."
            mv "$symlink_path" "$symlink_path.bak"
        fi
    fi

    # Create the symlink
    ln -s "$original_file" "$symlink_path"
    echo "Symlink created from '$symlink_path' to '$original_file'."
}

symlink_fish() {
  replace_with_symlink config.fish ~/.config/fish/config.fish
}

symlink_vim() {
  replace_with_symlink .vimrc ~/.vimrc

  #install vim plug
  if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]]; then
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi
}

symlink_wezterm() {
  replace_with_symlink wezterm.lua ~/.config/wezterm/wezterm.lua
}

symlink_picom() {
  replace_with_symlink picom.conf ~/.config/picom.conf
}

symlink_xmonad() {
  replace_with_symlink xmonad.hs ~/.xmonad/xmonad.hs
  replace_with_symlink xmobar.hs ~/.xmonad/xmobar.hs
}

#define system
OS=$(uname -s)

case $OS in
  Darwin)
    brew install \
      fish zoxide zellij uutils-coreutils eza fd tealdeer ncdu \
      gnupg pinentry-mac \
      temurin scrcpy cocoapods fvm \
      font-jetbrains-mono \
      iina steermouse monitorcontrol orbstack
    ;;
  Linux)
    distro=$(uname -v)

    #deps and utils for ubuntu
    if which apt &> /dev/null; then
      apt -y install fish zoxide eza fd-find tealdeer ncdu curl git vim htop tmux
    elif which emerge &> /dev/null; then
      emerge --quiet #TODO

      symlink_wezterm
      symlink_picom
      symlink_xmonad
    else
      echo "Unknown distro! I cant install deps and utils..."
      exit 1
    fi
    ;;

  *)
    echo "unknown operation system $OS"
    exit 1
    ;;
esac

symlink_fish
symlink_vim

#exec new shell
exec $(which fish) -c "clear && reset && echo \"have a nice day!\""
