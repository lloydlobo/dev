#!/usr/bin/env

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

git config --global user.email "lloydlobo4@gmail.com"
git config --global user.name "Lloyd Lobo"

cargo install stylua
