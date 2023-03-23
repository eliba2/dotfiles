#!/bin/bash

# vim
ln -s ${HOME}/.dotfiles/vim/.vimrc ${HOME}/.vimrc
ln -s ${HOME}/.dotfiles/vim/.gvimrc ${HOME}/.gvimrc

# nvim
ln -s ${HOME}/.dotfiles/neovim/init.vim ${HOME}/.config/nvim/init.vim
ln -s ${HOME}/.dotfiles/neovim/ginit.vim ${HOME}/.config/nvim/ginit.vim

# kitty
ln -s ${HOME}/.dotfiles/kitty/kitty.conf ${HOME}/.config/kitty/kitty.conf
ln -s ${HOME}/.dotfiles/kitty/pager ${HOME}/.config/kitty/pager
