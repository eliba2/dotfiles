"
" using tabs

" use tabs
"set tabstop=4       " The width of a TAB is set to 4.  " Still it is a \t. It is just that Vim will interpret it to be having a width of 4.
"set shiftwidth=4    " Indents will have a width of 4
"set noexpandtab    " Use tabs, not spaces
"set softtabstop=4   " Sets the number of columns for a TAB
"set autoindent       " Copy indent from current line when starting a new line (ai).


" using spaces
set tabstop=2       " The width of a TAB is set to 4.  " Still it is a \t. It is just that Vim will interpret it to be having a width of 4.
set shiftwidth=2    " Indents will have a width of 4
set expandtab       " Expand TABs to spaces
set softtabstop=0   " Sets the number of columns for a TAB
set autoindent       " Copy indent from current line when starting a new line (ai).
set smarttab      " Inserts blanks on a <Tab> key (as per sw, ts and sts).

" netrw scp bug workaround
autocmd BufRead scp://* :set bt=acwrite

" set vimdiff default to vertical (on rotated screen it changes)
set diffopt+=vertical


" mouse
set mouse=a
"patheon
" To disable a plugin, add it's bundle name to the following list
" let g:pathogen_blacklist = []

""call add(g:pathogen_blacklist, 'ctrlp')

" disabled, causes issues
"call pathogen#infect()

syntax on
filetype plugin indent on
" set js ident
autocmd FileType javascript setlocal sw=2 ts=2 sts=2
"mine
set number
"set relativenumber
"solarized (or other themes)
syntax enable
" smartcase (If you search for something containing uppercase characters, it will do a case sensitive search; if you search for something purely lowercase, it will do a case insensitive search. You can use \c and \C to override this)
set ignorecase
set smartcase

" for gitgutter - updates the display faster (default = ~5 seconds)
set updatetime=2000

" space will add a space in normal mode
nnoremap <space> i<space><esc>

"neocomplete
"let g:neocomplete#enable_at_startup = 1
 "<CR>: close popup and save indent.
"inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
"function! s:my_cr_function()
  "return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
   "For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
"endfunction
 "<TAB>: completion.
"inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
 "<C-h>, <BS>: close popup and delete backword char.
"inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
"inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
 "Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

"ctrl-p
"let g:ctrlp_map = '<c-p>'
""if has("gui_macvim")
""  let g:ctrlp_map = '<D-p>'
""endif
"let g:ctrlp_cmd = 'CtrlPCurWD'
"let g:ctrlp_working_path_mode = 'ra'
"set wildignore+=*.so,*.swp,*.zip
"let g:ctrlp_custom_ignore = '\v[\/](build-production|build-staging|build-production-monday|build-staging-monday|target|dist)|(\.(swp|ico|git|svn|sass-cache|tmp))$'
" let g:ctrlp_user_command = 'find %s -type f'
"let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
"      \ --ignore .git
"      \ --ignore .svn
"      \ --ignore node_modules
"      \ --ignore vendor
"      \ --ignore .DS_Store
"      \ --ignore .tmp
"      \ --ignore .sass-cache
"      \ --ignore "**/*.min.*"
"      \ -g ""'
"" eb - add mapping for insert mode
"imap <C-p> <Esc>:CtrlP<CR>
"" and enable paste in ctrlp
"if has("gui_macvim")
"  let g:ctrlp_prompt_mappings = { 'YankLine()': ['<D-v>'], 'CreateNewFile()': []  }
"endif

" setting the filetype
noremap <leader>tj :set filetype=javascript<CR>
noremap <leader>th :set filetype=html<CR>
noremap <leader>tp :set filetype=php<CR>
noremap <leader>tr :set filetype=rest<CR>

" Ale config
" ALE neovim, show virtual text
" let g:ale_virtualtext_cursor = 1
" highlight ALEVirtualTextError ctermfg=Red                                                    
" let g:ale_completion_enabled = 1
" let g:ale_completion_autoimport = 1
"
" nmap <silent> gd <Plug>(ale_go_to_definition)
" nmap <silent> gi <Plug>(ale_find_references)
" nmap <silent> gD <Plug>(ale_go_to_type_definition)
" nmap <silent> gr <Plug>(ale_rename)
" nnoremap K <Plug>(ale_hover)



let g:ale_linters = {
\ 'javascript': ['standard'], 
\ 'typescript': ['deno']
\}

" let js_fixers = ['prettier', 'eslint']
let g:ale_fixers = {
\   'javascript': ['standard'],
\   'typescript': ['deno'],
\   'typescriptreact': ['deno'],
\   'css': ['prettier'],
\   'json': ['prettier'],
\}
"
" let g:ale_deno_executable = '/Users/tikal/.deno/bin/deno'
let g:ale_deno_executable = 'deno'

"vim-airline
let g:airline#extensions#tabline#enabled = 2
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
" remove warning (mix-ident, etc)
let g:airline_section_warning=''
set laststatus=2
set t_Co=256
"let g:airline_theme='molokai'
let g:airline_theme='tomorrow'
" disable top buffer list
let g:airline#extensions#tabline#enabled = 0
" disable errors with neovim, as it uses the virtualtext
if !has('nvim')
let g:airline#extensions#ale#enabled = 1
endif

" nerdtree - mapping moved to gvimrc
"nnoremap <C-b> :NERDTreeToggle<CR>
"inoremap <C-b> <Esc>:NERDTreeToggle<CR>
"if has("gui_macvim")
  "nnoremap <D-k> :NERDTreeToggle<CR>
  "inoremap <D-k> <Esc>:NERDTreeToggle<CR>
"endif

" nnoremap º :NERDTreeFind<CR>
" let NERDTreeChDirMode=2
""let NERDTreeChDirMode=0
" lets try on the right
" let g:NERDTreeWinPos = "right"


" fern (file explorer)
let g:fern#renderer = "nerdfont"
nnoremap <M-b> :Fern %:h -drawer -toggle<CR>
" inoremap <M-l> <Esc>:Fern %:h -drawer -toggle<CR>
nnoremap <M-l> :Fern . -reveal=% -drawer<CR>
function! s:init_fern() abort
  " Define NERDTree like mappings
  nmap <buffer> t <Plug>(fern-action-open:tabedit)
  nmap <buffer> T <Plug>(fern-action-open:tabedit)gT
  nmap <buffer> s <Plug>(fern-action-open:vsplit)
  nmap <buffer> ma <Plug>(fern-action-new-path)
  nmap <buffer> r <Plug>(fern-action-reload)
  nmap <buffer> cd <Plug>(fern-action-cd)
  nmap <buffer> CD gg<Plug>(fern-action-cd)<C-o>

" Perform enter in explorer style but expand in drawer style
" ?? doesn't work ??
  nmap <buffer><expr>
        \ <Plug>(fern-my-expand-or-enter)
        \ fern#smart#drawer(
        \   "\<Plug>(fern-open-or-expand)",
        \   "\<Plug>(fern-open-or-enter)",
        \ )
  nmap <buffer><expr>
        \ <Plug>(fern-my-collapse-or-leave)
        \ fern#smart#drawer(
        \   "\<Plug>(fern-action-collapse)",
        \   "\<Plug>(fern-action-leave)",
        \ )
  nmap <buffer><nowait> l <Plug>(fern-my-expand-or-enter)
  nmap <buffer><nowait> h <Plug>(fern-my-collapse-or-leave)

  augroup my-glyph-palette
    autocmd! *
    autocmd FileType fern call glyph_palette#apply()
    autocmd FileType nerdtree,startify call glyph_palette#apply()
  augroup END


endfunction



" nerdcommenter
noremap <leader>\ :call nerdcommenter#Comment(0,"toggle")<CR>
" noremap <leader>\ :TComment<CR>


" js beautifieer (+html/css/json/jsx)
noremap <leader>bj :call JsBeautify()<CR>
noremap <leader>bh :call HtmlBeautify()<CR>
noremap <leader>bn :call JsonBeautify()<CR>
noremap <leader>bx :call JsxBeautify()<CR>
noremap <leader>bs :call CSSBeautify()<CR>
" beautify for selected
noremap <leader>rj :call RangeJsBeautify()<CR>
noremap <leader>rh :call RangeHtmlBeautify()<CR>
noremap <leader>rn :call RangeJsonBeautify()<CR>
noremap <leader>rx :call RangeJsxBeautify()<CR>
noremap <leader>rs :call RangeCSSBeautify()<CR>



" eb searching / highlight search
set incsearch
set hlsearch
" eb - idention
set cindent
" auto reload files
set autoread


" neovim live substitution
if has('nvim')
set inccommand=split
endif



"if !has('nvim')
  "set gfn=Monaco:h13
"endif

" Unite
"let g:unite_source_history_yank_enable = 1
"call unite#filters#matcher_default#use(['matcher_fuzzy'])
"nnoremap <leader>t :<C-u>Unite -no-split -buffer-name=files   -start-insert file_rec/async:!<cr>
"nnoremap <leader>f :<C-u>Unite -no-split -buffer-name=files   -start-insert file<cr>
"nnoremap <leader>r :<C-u>Unite -no-split -buffer-name=mru     -start-insert file_mru<cr>
"nnoremap <leader>o :<C-u>Unite -no-split -buffer-name=outline -start-insert outline<cr>
"nnoremap <leader>y :<C-u>Unite -no-split -buffer-name=yank    history/yank<cr>
"nnoremap <leader>e :<C-u>Unite -no-split -buffer-name=buffer  buffer<cr>


" Custom mappings for the unite buffer
"autocmd FileType unite call s:unite_settings()
"function! s:unite_settings()
  " Play nice with supertab
"  let b:SuperTabDisabled=1
  " Enable navigation with control-j and control-k in insert mode
"  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
"  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
"endfunction

" copy (also) 2 clipboard
set clipboard=unnamed
"set clipboard+=unnamedplus
"
" copy to clipboard with xclip
vnoremap <silent> <Leader>y :w !xclip -i -sel c<CR><CR>


" ack with ag
"if executable('ag')
  "let g:ackprg = 'ag --vimgrep --path-to-ignore ~/.config/ag'
"endif

function! SearchText(isVisual)
  if a:isVisual
    let text = GetVisualSelection()
    exec ':CtrlSF -- "'.text.'"'
  else
    let text = expand("<cword>")
    exec ':CtrlSF '.text
  endif
endfunction
" bind a-e to grep word under cursor
nnoremap <A-e> :call SearchText(0)<CR>
vnoremap <A-e> :call SearchText(1)<CR>
" osx equivalent
nnoremap <D-e> :call SearchText(0)<CR>
vnoremap <D-e> :call SearchText(1)<CR>


nnoremap <Leader>s :CtrlSF<Space>
nnoremap <Leader>c :CtrlSFToggle<CR>
"let g:ctrlsf_auto_close = 0
let g:ctrlsf_position = 'right'
let g:ctrlsf_backend = 'ag'

let g:ctrlsf_extra_backend_args = {
    \ 'ag': '--path-to-ignore ~/.config/ag/.ignore'
    \ }
" not working??
let g:ctrlsf_auto_focus = {
    \ "at": "start"
    \ }
let g:ctrlsf_mapping = {
    \ "vsplit": "<C-v>"
    \ }
" Old ack-style
"nnoremap <C-f> :Ack! "\b<C-R><C-W>\b"<CR>:cw<CR>
"cnoreabbrev Ack Ack!
"nnoremap <Leader>a :Ack!<Space>

set nocompatible
filetype plugin on
" match it plugin
" runtime macros/matchit.vim

" manage hidden buffers
set hidden

"Store temporary files in a central spot
set backupdir=~~/tmp,/tmp
"set directory=~/tmp,/tmp
set directory^=$HOME/.vim/swap//

" rainbow
let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle

" change cursor in different modes, iterm2
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" eb - select latest pasted text and ident it
noremap <leader>ip '[V']=


function! DeleteHiddenBuffers()
  redir => buffersoutput
  buffers
  redir END
  let buflist = split(buffersoutput,"\n")
  for item in filter(buflist,"v:val[5] == 'h'")
    exec 'bdelete ' . item[:2]
  endfor
endfunction

" nnoremap <leader>q :call DeleteHiddenBuffers()<CR>
nnoremap <leader>q :q<CR>


" pretty print json
" nnoremap <leader>j :%!python -m json.tool<CR>


" html complete
" filenames like *.xml, *.html, *.xhtml, ...
let g:closetag_filenames = "*.html,*.html.erb,*.xhtml,*.phtml"


" signify
let g:signify_vcs_list = [ 'git' ]
let g:signify_line_highlight = 0


" Vimscript eb settings ---------------------- {{{
 
"eb - delete without cut (updated to include more)
nnoremap d "_d
vnoremap d "_d
nnoremap x "_x
nnoremap D "_D
vnoremap D "_D
nnoremap c "_c
vnoremap c "_c
nnoremap C "_C
vnoremap C "_C

" edit vimrc
nnoremap <leader>vi :vsplit $MYVIMRC<cr>
" save vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>
" edit gvimrc
nnoremap <leader>gi :vsplit $HOME/.gvimrc<cr>
" save gvimrc
nnoremap <leader>sg :source $HOME/.gvimrc<cr>
" out of edit mode
inoremap jj <esc>

" folding
set foldmethod=indent
" set foldcolumn=1
set foldlevelstart=99
"set nofoldenable "don't open by default
"command-[] next/prev buffer. only for macvim
"if has("gui_macvim")
  "noremap <D-[> :bprev<CR>
  "noremap <D-]> :bnext<CR>
  "imap <D-[> <Esc>:bprev i<CR>
  "imap <D-]> <Esc>:bnext i<CR>
"endif


" up/down in long lines
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'


" add semicolor at the and of line
inoremap <leader>; <C-o>A;<esc>
nnoremap <leader>; A;<esc>

" allow movment in insert mode: end and beginning of line
inoremap <C-e> <C-o>$
inoremap <C-a> <C-o>^




" Show as much as possible of a wrapped last line, not just "@".
set display=lastline

" tagbar toggle
" nmap <C-x> :TagbarToggle<CR>

" highlight current line
if !has("nvim")
  set cursorline
endif
" all o these - to speed up
"set ttyfast
"set lazyredraw
"set re=1
"augroup ft_rb
"    au!
"    " fix the SLOOOW syntax highlighting
"    au FileType ruby setlocal re=1 foldmethod=manual
"augroup END
"syntax sync minlines=256


" close quick fix; either l-c or esc in normal mode (not used with ctrlfs)
"nnoremap <leader>c :copen<CR>
"nnoremap <ESC> :ccl<CR>

" remove highlight
  nnoremap <leader>h :noh<CR>

" }}}


"add minus to word
set iskeyword+=-

" fzf
set rtp+=/usr/local/opt/fzf
let g:fzf_launcher = "~/bin/fzf-macvim.sh %s"
" mapping moved to gvimrc
"nnoremap <c-p> :FZF<cr>
" moved to rg
" --skip-vcs-ignores was used where the root holds other projects where it has
"  .gitignore to these. I removed this parameter; better to add these in the .ignore file
let $FZF_DEFAULT_COMMAND= 'ag -g "" --path-to-ignore ~/.config/ag/.ignore --silent '
" make fzf's AG skip vcs ignores and use ours. and, work only on contect (not files)
" command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>,'--path-to-ignore ~/.config/ag/.ignore', {'options': '--delimiter : --nth 4..'}, <bang>0)
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>,'--path-to-ignore ~/.config/ag/.ignore --silent ', {'options': '--expect=ctrl-x,ctrl-v --delimiter : --nth 4 --multi --reverse --preview "~/.vim/plugged/fzf.vim/bin/preview.sh {}"'}, <bang>0)
" note that alt-p will use RgFiles instead of default
" back to ag
" let $FZF_DEFAULT_COMMAND= 'rg --files --hidden --no-ignore-vcs --ignore-file=~/.config/ag/.ignore'
" command! -bang -nargs=* RgFiles call fzf#run(fzf#wrap({'source': 'rg --files --hidden --no-ignore-vcs --ignore-file=~/.config/ag/.ignore', 'options': '--expect=ctrl-x,ctrl-v --multi --reverse --preview "~/.vim/plugged/fzf.vim/bin/preview.sh {}"' }))

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

nnoremap <M-e> :call fzf#vim#ag('.','--path-to-ignore ~/.config/ag/.ignore --silent ', {'options': '--expect=ctrl-x,ctrl-v --multi --reverse --preview "~/.vim/plugged/fzf.vim/bin/preview.sh {}" --query '.expand('<cword>')})<CR>


" nnoremap <M-e> :call fzf#vim#files('.', {'options':'--query '.expand('<cword>')})<CR>


"""""""""""fzf in gloating window
" Reverse the layout to make the FZF list top-down
let $FZF_DEFAULT_OPTS='--layout=reverse'

" Using the custom window creation function
let g:fzf_layout = { 'window': 'call FloatingFZF()' }

" allow paste in FZF with Alt-v (e.g. terminal mode)
tnoremap <expr> <A-v> '<C-\><C-N>pi'

" Function to create the custom floating window
function! FloatingFZF()
  " creates a scratch, unlisted, new, empty, unnamed buffer
  " to be used in the floating window
  let buf = nvim_create_buf(v:false, v:true)

  " 90% of the height
  let height = float2nr(&lines * 0.9)
  " 80% of the height
  let width = float2nr(&columns * 0.8)
  " horizontal position (centralized)
  let horizontal = float2nr((&columns - width) / 2)
  " vertical position (one line down of the top)
  let vertical = 1

  let opts = {
        \ 'relative': 'editor',
        \ 'row': vertical,
        \ 'col': horizontal,
        \ 'width': width,
        \ 'height': height
        \ }

  " open the new window, floating, and enter to it
  call nvim_open_win(buf, v:true, opts)
endfunction
"""""""""""endof fzf in gloating window

"endfunction
"call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
"call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
"call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
"call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
"call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
"call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
"call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')

" nerdtree tree colors (vim-nerdtree-syntax-highlight)
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1
"Highlight folders using exact match
let g:NERDTreeHighlightFolders = 1 " enables folder icon highlighting using exact match
let g:NERDTreeHighlightFoldersFullName = 1 " highlights the folder name


" Trigger configuration (Optional) - ultrasnip
let g:UltiSnipsExpandTrigger="<C-9>"

" auto pairs no shortcuts (no meta)
let g:AutoPairsShortcutToggle=''


" startify
let g:startify_files_number = 3
" in order to be compatability vim/nvim
let g:startify_session_dir = '~/.vim/session'



" Simple re-format for minified Javascript
command! UnMinify call UnMinify()
function! UnMinify()
    %s/{\ze[^\r\n]/{\r/g
    %s/){/) {/g
    %s/};\?\ze[^\r\n]/\0\r/g
    %s/;\ze[^\r\n]/;\r/g
    %s/[^\s]\zs[=&|]\+\ze[^\s]/ \0 /g
    normal ggVG=
endfunction


" terminal
" exit terminal mode

tnoremap jj <C-\><C-n>
" move between windows in terminal mode
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l

" autocmd FileType fzf tnoremap <ESC> :q<CR>

" rest split mode (vertical-horizontal)
" let vrc_horizontal_split=1
" It's useful when we don't want to include the response header in the output view but still want the output to be formatted or syntax-highlighted.
let g:vrc_response_default_content_type = 'application/json'


" git blame auto start, only for nvim (w virtual text, sorry vim)
" if has("nvim")
" let g:blameLineDisplayTimer = 2500
" nmap <silent> <leader>b :ToggleBlameLine<CR>
" endif


" fugitive. some disabled because of security!
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gc :G commit<CR>
nnoremap <leader>gd :Gdiffsplit<CR>
nnoremap <leader>gl :G log<CR>
nnoremap <leader>gp :G grep<Space>
" nnoremap <leader>gb :G branch --sort=-committerdate<CR>
nnoremap <leader>gL :execute "Git log --patch -- ".expand('%p')<CR>
" custom defined
nnoremap <leader>gm :G blame<CR>
nnoremap <leader>gb :G branch<CR>
nnoremap <leader>gg :Merginal<CR>




"""" git checkout pipe to fzf
function! s:changebranch(branch)
    execute 'Git checkout' . a:branch
    call feedkeys("i")
endfunction

function! s:open_branch_fzf(line)
  let l:parser = split(a:line)
  let l:branch = l:parser[0]
  if l:branch ==? '*'
    let l:branch = l:parser[1]
  endif
  execute '!git checkout ' . l:branch
endfunction

command! -bang -nargs=0 Gbranch
  \ call fzf#vim#grep(
  \   'git branch -v', 0,
  \   {
  \     'sink': function('s:open_branch_fzf')
  \   },
  \   <bang>0
  \ )




"""""" start of Coc configuration

" if hidden is not set, TextEdit might fail.
set hidden
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup
" Better display for messages
" set cmdheight=2
" You will have bad experience for diagnostic messages when it's default 4000.
" set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
noremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
"Use <Tab> and <S-Tab> to navigate the completion list:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
" coc-prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)




""" end of coc configuration


"indentline - don't change conceal level
let g:indentLine_setConceal = 0


" conceal for javascript-vim plugin
let g:javascript_conceal_function             = "Ä"
let g:javascript_conceal_null                 = "¿"
let g:javascript_conceal_this                 = "@"
let g:javascript_conceal_return               = "?"
let g:javascript_conceal_undefined            = "À"
let g:javascript_conceal_NaN                  = "?"
let g:javascript_conceal_prototype            = "¦"
let g:javascript_conceal_static               = "¥"
let g:javascript_conceal_super                = "½"
let g:javascript_conceal_arrow_function       = "?"
let g:javascript_conceal_noarg_arrow_function = "??"
let g:javascript_conceal_underscore_arrow_function = "??"




" set title to the current dir
if has("nvim")
set title
augroup dirchange
autocmd!
autocmd DirChanged * let &titlestring=v:event['cwd']
augroup END
endif

" blink the cursor
set guicursor=n-ci:iCursor-blinkwait1200-blinkon800-blinkoff600


" vim-node-inspect
nnoremap <F3> :NodeInspectStart<cr>
nnoremap <F5> :NodeInspectRun<cr>
nnoremap <F4> :NodeInspectConnect("127.0.0.1:7000")<cr>
nnoremap <F8> :NodeInspectStepOver<cr>
nnoremap <F7> :NodeInspectStepInto<cr>
nnoremap <F10> :NodeInspectStepOut<cr>
nnoremap <F2> :NodeInspectStop<cr>
nnoremap <F9> :NodeInspectToggleBreakpoint<cr>
nnoremap <f6> :NodeInspectRemoveAllBreakpoints<cr>
nnoremap <f12> :NodeInspectToggleWindow<cr>

let g:nodeinspect_window_pos = 'right'
let g:nodeinspect_auto_watch = 1


" base 64 decode
" https://stackoverflow.com/questions/1533565/how-to-get-visually-selected-text-in-vimscript
function! GetVisualSelection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
   return join(lines, "\n")
endfunction

function! EncodeDecodeBase64(encodeDecode)
let selection = GetVisualSelection()
if len(selection) == 0
" no selection, run on the whole buffer
execute("%!python -m base64 -".a:encodeDecode)

else
" exec on selection
execute("'<,'>!python -m base64 -".a:encodeDecode)
endif
endfunction


" note: can also use nodejs
" node -e "const fs=require('fs');var s=fs.readFileSync(0);console.log(unescape(s))"
" escape = 1: escape, 0 is for unescape
function! UrlEscape(escape)
  let selection = GetVisualSelection()
  if len(selection) == 0
    " no selection, run on the whole buffer
    if a:escape
      execute("%! python -c 'import sys, urllib as ul; print ul.quote(sys.stdin.read());'")
    else
      execute("%! python -c 'import sys, urllib as ul; print ul.unquote(sys.stdin.read());'")
    endif
  else
    " exec on selection
    if a:escape
      execute("'<,'>!python -c 'import sys, urllib as ul; print ul.quote(sys.stdin.read());'")
    else
      execute("'<,'>!python -c 'import sys, urllib as ul; print ul.unquote(sys.stdin.read());'")
    endif
  endif
endfunction


noremap <leader>6 :call EncodeDecodeBase64('e')<CR>
noremap <leader>7 :call EncodeDecodeBase64('d')<CR>
noremap <leader>8 :call UrlEscape(1)<CR>
noremap <leader>9 :call UrlEscape(0)<CR>



" open terminal in down split
" noremap <leader>e :belowright split|resize 20|terminal<CR>


function! JumpToNextBufferInJumplist(dir) " 1=forward, -1=backward
    let jl = getjumplist() | let jumplist = jl[0] | let curjump = jl[1]
    let jumpcmdstr = a:dir > 0 ? '<C-O>' : '<C-I>'
    let jumpcmdchr = a:dir > 0 ? '<C-O>' : '<C-I>'
    let searchrange = a:dir > 0 ? range(curjump+1,len(jumplist))
                              \ : range(curjump-1,0,-1)
    for i in searchrange
        if jumplist[i]["bufnr"] != bufnr('%')
            let n = (i - curjump) * a:dir
            echo "Executing ".jumpcmdstr." ".n." times."
            execute "silent normal! ".n.jumpcmdchr
            break
        endif
    endfor
endfunction
nnoremap <leader><C-O> :call JumpToNextBufferInJumplist(-1)<CR>
nnoremap <leader><C-I> :call JumpToNextBufferInJumplist( 1)<CR>



" easy jump (eb)
noremap <c-k> 5k
noremap <c-j> 5j

" telescope
" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>



function! ToggleQuotes()
  " get the WORD under the cursor
  let word = expand("<cWORD>")
  if len(word) < 4
    return
  endif
  " if any quotes from both sides, remove them
  let fc = word[0]
  let lc = word[len(word)-1]
  if lc == '"' && lc == fc
    normal ds"
  elseif lc == "'" && lc == fc
    normal ds'
  else
    normal csw'
  endif
endfunction

" vim-surround toggle quote helper function
nnoremap <c-'> :call ToggleQuotes()<CR>

" Specify a direcory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.vim/plugged')


" Make sure you use single quotes
Plug 'tpope/vim-fugitive'
" branch handling fugitive extension
Plug 'idanarye/vim-merginal'
" commit browser
Plug 'junegunn/gv.vim'
" show changes
Plug 'airblade/vim-gitgutter'

"if has("nvim")
  " the framework (complete)
  "Plug 'roxma/nvim-completion-manager'
  " php
  "Plug 'roxma/LanguageServer-php-neovim',  {'do': 'composer install && composer run-script parse-stubs'}
  " css
  "Plug 'calebeby/ncm-css'
  " javascript
  "Plug 'roxma/nvim-cm-tern',  {'do': 'npm install'}
"endif

" completion manager (like vsc)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

"Far - find & replace
Plug 'brooth/far.vim'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" nerdtree an dplugins
Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'Xuyuanp/nerdtree-git-plugin'


" tree viewer alternative
" Plug 'lambdalisue/fern.vim'
" Plug 'lambdalisue/nerdfont.vim'
" Plug 'lambdalisue/glyph-palette.vim'
" Plug 'lambdalisue/fern-renderer-nerdfont.vim'
" Plug 'lambdalisue/fern-git-status.vim'

" color schemes
" Plug 'dracula/vim', { 'as': 'dracula' }
" Plug 'KeitaNakamura/neodark.vim'
" Plug 'joshdick/onedark.vim'
Plug 'ayu-theme/ayu-vim'



Plug 'dyng/ctrlsf.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

"Plug 'xolox/vim-easytags'
"Plug 'xolox/vim-misc'
" tags generation
" Plug 'ludovicchabant/vim-gutentags'
" jsctags (and others support for gutentags
" Plug 'tkonolige/ctags-shim'

"Plug 'sjl/gundo.vim' " undo tree visualiser

" Plug 'sheerun/vim-polyglot' " language syntax/ident
Plug 'mhinz/vim-startify'

" Plug 'tomtom/tcomment_vim'

Plug 'scrooloose/nerdcommenter'

"Plug 'Valloric/YouCompleteMe'

"Plug 'cohama/lexima.vim'

"Plug 'qpkorr/vim-bufkill'


" Plug 'dense-analysis/ale'

" Plug 'cskeeters/vim-smooth-scroll'

" Plug 'pangloss/vim-javascript'
" this sets the filetype to javascript.jsx which breaks completion plugins
" Plug 'mxw/vim-jsx'
" Plug 'elzr/vim-json'

Plug 'mattn/emmet-vim'

" ES2015 code snippets
" Plug 'epilande/vim-es2015-snippets'
" React code snippets
" Plug 'epilande/vim-react-snippets'
" Ultisnips
" Plug 'SirVer/ultisnips'

" ident lines
"Plug 'Yggdroot/indentLine'

" vim-esearch
" Plug 'eugen0329/vim-esearch'

" multiple cursors
Plug 'terryma/vim-multiple-cursors'

" surround
Plug 'tpope/vim-surround'

" node navigation
Plug 'moll/vim-node'

" auto brackets
" Plug 'jiangmiao/auto-pairs'

" auto brackets 2
" Plug 'rstacruz/vim-closer'

" Icons
"Plug 'ryanoasis/vim-devicons'

" marks on left line
Plug 'kshenoy/vim-signature'

" as is
"Plug 'maksimr/vim-jsbeautify'

" as is (colortheme)
" Plug 'NLKNguyen/papercolor-theme'


" static code analysis
" Plug 'vim-syntastic/syntastic'

" rest console
Plug 'diepm/vim-rest-console'

" auto idention detectin
Plug 'tpope/vim-sleuth'

" git blame (not found in others...)
" Plug 'zivyangll/git-blame.vim'

" complete html
" Plug 'alvan/vim-closetag'

" find project root
" Plug 'dbakker/vim-projectroot'

" match html tag
" Plug 'gregsexton/MatchTag'

" change root project according to...
" Plug 'airblade/vim-rooter'

" language server protocol
" Plug 'autozimu/LanguageClient-neovim', {
"     \ 'branch': 'next',
"     \ 'do': 'bash install.sh',
"     \ }

" Plug 'vim-hexokinase' " color inline. need to check which plugin does it currently before enabling




" the best node-debugger in the world
Plug 'eliba2/vim-node-inspect'

" typescript
"Plug 'leafgarland/typescript-vim'

if has("nvim")
  " treesitting
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/playground'
  " telescope. fzf alike
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  "Plug 'nvim-telescope/telescope.nvim'
endif

" Initialize pugin system
call plug#end()



"nvim treesitter
if has("nvim")
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = {}, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = {},  -- list of language that will be disabled
    -- Setting his to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF
endif



" color scheme
"set background=dark
"colorscheme solarized
"colorscheme wombat
"colorscheme badwolf
"colorscheme pyte
"colorscheme jellybeans
"colorscheme molokai
"colorscheme codeschool
"colorscheme Tomorrow-Night-Eighties
"colorscheme onedark
"color dracula
"color neodark
"colorscheme material-monokai
" set background=dark
" colorscheme PaperColor
" ayu theme
set termguicolors
let ayucolor="dark"
colorscheme ayu


