# /bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

$SCRIPT_DIR/install-apt-packages.sh

mkdir -p ~/.vim/bundle/
mkdir -p ~/

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm


link() {
    if [ -z "$1" ] || [ -z "$2" ];
    then
        echo "EMPTY LINK PATHS"
        return 1
    fi
    ABS_TARGET=$(readlink -f $1)
    ABS_LINK=$2
    echo "New link $ABS_LINK"
    echo "Points to $ABS_TARGET"
    ln -sfb $ABS_TARGET $ABS_LINK

    return 0
}

echo
link "$SCRIPT_DIR/.bashrc" "$HOME/.bashrc"
echo
link "$SCRIPT_DIR/.inputrc" "$HOME/.inputrc"
echo
link "$SCRIPT_DIR/.vimrc" "$HOME/.vimrc"
echo
link "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"
echo
