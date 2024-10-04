sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update

sudo apt-get install -y \
    gnome-keyring \
    chrpath diffstat zstd \
    ninja-build \
    python3.12

sudo ln -fs /usr/bin/python3.12 /usr/bin/python3

python3 -m ensurepip --upgrade
pip3 install ranger-fm poetry
