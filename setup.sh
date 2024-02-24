#!/bin/bash

# vim
ln -s ${HOME}/.dotfiles/vim/.vimrc ${HOME}/.vimrc
ln -s ${HOME}/.dotfiles/vim/.gvimrc ${HOME}/.gvimrc

# nvim
ln -s ${HOME}/.dotfiles/neovim/init.vim ${HOME}/.config/nvim/init.vim
ln -s ${HOME}/.dotfiles/neovim/ginit.vim ${HOME}/.config/nvim/ginit.vim
ln -s ${HOME}/.dotfiles/neovim/lua ${HOME}/.config/nvim/lua

# kitty
# note: pager uses lua script which is linked in lua above
ln -s ${HOME}/.dotfiles/kitty/kitty.conf ${HOME}/.config/kitty/kitty.conf

# phoenix (osx only, https://kasper.github.io/phoenix/)
ln -s ${HOME}/.dotfiles/phoenix/phoenix.js ${HOME}/.phoenix.js
