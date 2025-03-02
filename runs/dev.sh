#!/usr/bin/env

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

git config --global user.email "lloydlobo4@gmail.com"
git config --global user.name "Lloyd Lobo"
git config --global init.defaultBranch master
# [ ] Add color diffing for renamed/moved (avoid noise)

cargo install stylua

# =============================================================================
# Needs development installation of Lua5.1
#
# luarocks installed in ./neovim.sh
# pushd /tmp/luarocks-3.11.0
# (
#     wget --output-document /tmp/luarocks.tar.gz https://luarocks.org/releases/luarocks-3.11.0.tar.gz
#     tar zxpf /tmp/luarocks.tar.gz -C /tmp
#     cd
#     ./configure && make && sudo make install
# )
# popd
#
# luarocks install luacheck

# =============================================================================
# Dogfooding

# git clone https://github.com/lloydlobo/mausam
# git clone https://github.com/lloydlobo/gitback
# git clone https://github.com/lloydlobo/dirview
