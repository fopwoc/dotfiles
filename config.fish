set fish_greeting
set -g fish_prompt_pwd_dir_length 3
set -g fish_prompt_pwd_full_dirs 3

set -Ux PAGER less
set -Ux EDITOR vim
set -Ux VISUAL vim

set -x PATH ~/.local/bin $PATH

set -l os (uname)
if test "$os" = Darwin
    set -x GPG_TTY $(tty)

    set -U JAVA_HOME "/Applications/Android Studio.app/Contents/jbr/Contents/Home"
    set -U fish_user_paths ~/Library/Android/sdk/tools $fish_user_paths
    set -U fish_user_paths ~/Library/Android/sdk/platform-tools $fish_user_paths
    set -U fish_user_paths /opt/homebrew/opt/uutils-coreutils/libexec/uubin $fish_user_paths
    set -U fish_user_paths /opt/homebrew/bin $fish_user_paths
    set -U fish_user_paths "/Applications/Android Studio.app/Contents/MacOS" $fish_user_paths

    alias tmux "zellij"
    alias ubuntu "docker run -it -v /tmp/ubuntu:/tmp/ubuntu --privileged ubuntu:latest bash"
    alias qbittorrent 'docker run -d --name=qbittorrent -e PUID=1000 -e PGID=1000 -e TZ=Europe/Moscow -p 8080:8080 -p 6881:6881 -p 6881:6881/udp -v /tmp/qbittorrent:/config -v ~/Downloads/torrent:/downloads --restart unless-stopped lscr.io/linuxserver/qbittorrent:latest'

else if test "$os" = Linux
    # do things for Linux
end

if type -q zoxide
    zoxide init fish --cmd j | source
end

# Check if 'eza' exists
if type -q eza
    alias ls "eza"
    alias l "eza -la --group-directories-first"
    alias lg "l --git"
    alias lt "l --tree --level 2"
else
    alias l 'ls -la'
end

function fish_prompt
    # Capture the exit status of the last command
    set last_status $status

    # Line break
    echo

    # Set the username color: red for root, magenta for others
    if test $USER = 'root'
        set_color red
    else
        set_color magenta
    end

    # Print username
    printf '%s' $USER
    set_color normal
    printf '@'

    # Print hostname in yellow
    set_color yellow
    echo -n (prompt_hostname)
    set_color normal
    printf ': '

    # Print current working directory in default cwd color
    set_color $fish_color_cwd
    printf '%s' (prompt_pwd)
    set_color normal

    # Print the exit status in red if it's non-zero (indicating an error)
    if test $last_status -ne 0
        set_color red
        printf ' [✘ %d]' $last_status
        set_color normal
    end

    # Line break
    echo

    # Print the lambda symbol for the next input
    printf 'λ '
    set_color normal
end

# Right prompt function to display the current time in green
function fish_right_prompt
    # Print the current time in green
    set_color green
    printf '[%s]' (date "+%H:%M:%S")
    set_color normal
end

fastfetch -s Title:Separator:OS:Host:Kernel:Uptime:Packages:Shell:Display:CPU:GPU:Memory:Swap:Disk:LocalIp:Battery:PowerAdapter:Locale:Break:Colors
