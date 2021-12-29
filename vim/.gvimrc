if has("gui_macvim")
  function! RemoveSplit()
    if winnr('$') > 1
exec 'bd'
    else
exec 'BD'
    endif
  endfunction

  macmenu &File.Print key=<nop>
  map <D-p> :FZF<CR>
  macmenu &Tools.Make key=<nop>
  " map <D-b> :NERDTreeToggle<CR>
  macmenu &File.Close key=<nop>
  map <D-w> :call RemoveSplit()<CR>
  set guifont=Menlo\ Regular:h13
endif

if has("nvim")
  set clipboard+=unnamedplus
  " the first uses alt, the second uses the command button
  map π :Files<CR>
  map … :Ag<CR>
  map ÷ :BLines<CR>
  map æ :BTags<CR>
  map ˆ :Buffers<CR>
  map ¡ :GFiles?<CR>
  map ™ :Marks<CR>
  map £ :History<CR>
  map ∫ :NERDTreeToggle<CR>
  map ¬ :NERDTreeFind<CR>
  map ∆ :m +1<CR>
  map ˚ :m -2<CR>
  map † :tabnew<CR>
  nnoremap ¥ :27 split<CR><C-w><C-w> :term<CR><ESC>i
  " alt-s save
  noremap <silent> ß :update<CR>
  vnoremap <silent> ß <C-C>:update<CR>
  inoremap <silent> ß <C-O>:update<CR>

  map <D-p> :Files<CR>
  map <D-;> :Ag<CR>
  map <D-/> :BLines<CR>
  map <D-'> :BTags<CR>
  map <D-i> :Buffers<CR>
  map <D-1> :GFiles?<CR>
  map <D-2> :Marks<CR>
  map <D-3> :History<CR>
  map <D-b> :NERDTreeToggle<CR>
  map <D-l> :NERDTreeFind<CR>
  map <D-j> :m +1<CR>
  map <D-k> :m -2<CR>
  map <D-t> :tabnew<CR>
  noremap <D-y> :27 split<CR><C-w><C-w> :term<CR><ESC>i
  " ctrl-s save
  noremap <silent> <D-s> :update<CR><ESC>
  vnoremap <silent> <D-s> <C-C>:update<CR><ESC>
  inoremap <silent> <D-s> <C-O>:update<CR><ESC>
  " ctrl-tab switch tab
  noremap <c-tab> gt
  vnoremap <c-tab> <C-C>gt
  inoremap <c-tab> <C-O>gt
endif


