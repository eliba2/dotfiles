" use tabs
"set tabstop=4       " The width of a TAB is set to 4.  " Still it is a \t. It is just that Vim will interpret it to be having a width of 4.
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
"set smartcase

" for gitgutter - updates the display faster (default = ~5 seconds)
set updatetime=2000

" space will add a space in normal mode
nnoremap <space> i<space><esc>

" setting the filetype
noremap <leader>tj :set filetype=javascript<CR>
noremap <leader>tn :set filetype=json<CR>
noremap <leader>th :set filetype=html<CR>
noremap <leader>tp :set filetype=php<CR>
noremap <leader>tr :set filetype=rest<CR>

" cursor line; disabled by default, filetype based (ftplugin) will set it for
" the appropriate types
set nocuc

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


set clipboard+=unnamedplus

if has("nvim")
  map <D-p> :Files<CR>
  map <D-;> :Rg<CR>
  map <D-/> :BLines<CR>
  map <D-'> :BTags<CR>
  map <D-i> :Buffers<CR>
  map <D-1> :History<CR>
  map <D-2> :Marks<CR>
  map <D-3> :GFiles?<CR>
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

" copy (also) 2 clipboard
" set clipboard=unnamed

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


"nmap     <Leader>f <Plug>CtrlSFPrompt
"vmap     <Leader>f <Plug>CtrlSFVwordPath
"vmap     <Leader>fF <Plug>CtrlSFVwordExec
"nmap     <Leader>fn <Plug>CtrlSFCwordPath
"nmap     <Leader>fp <Plug>CtrlSFPwordPath
"nnoremap <Leader>fo :CtrlSFOpen<CR>
"nnoremap <Leader>ft :CtrlSFToggle<CR>
"inoremap <Leader>ft <Esc>:CtrlSFToggle<CR>


nnoremap <Leader>s :CtrlSF<Space>
nnoremap <Leader>x :CtrlSFToggle<CR>
"let g:ctrlsf_auto_close = 0
let g:ctrlsf_position = 'right'
let g:ctrlsf_backend = 'rg'
let g:ctrlsf_open_left = 1

let g:ctrlsf_extra_backend_args = {
    \ 'rg': '--ignore-file ~/.config/ag/.ignore'
    \ }
"let g:ctrlsf_extra_backend_args = {
    "\ 'ag': '--path-to-ignore ~/.config/ag/.ignore'
    "\ }
" not working??
let g:ctrlsf_auto_focus = {
    \ "at": "start"
    \ }
let g:ctrlsf_mapping = {
    \ "vsplit": "<C-v>"
    \ }
" regex by default
let g:ctrlsf_regex_pattern = 1
" case insensitive
let g:ctrlsf_case_sensitive = 'no'
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

" quit; close current buffer. if no buffers left, closes vim
nnoremap <leader>qq :q<CR>
" close current tab
nnoremap <leader>w :tabclose<CR>


" pretty print json
" nnoremap <leader>j :%!python3 -m json.tool<CR>


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
" source vimrc
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


" up/down in long  lines
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

" highlight current line
if !has("nvim")
  set cursorline
endif
" remove highlight
nnoremap <C-h> :noh<CR>

" fzf
set rtp+=/usr/local/opt/fzf
let g:fzf_launcher = "~/bin/fzf-macvim.sh %s"
" allow pasting (c-r *)
autocmd! FileType fzf tnoremap <expr> <C-r> getreg(nr2char(getchar()))
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
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=* Rg
  \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

" nnoremap <M-e> :call fzf#vim#ag('.','--path-to-ignore ~/.config/ag/.ignore --silent ', {'options': '--expect=ctrl-x,ctrl-v --multi --reverse --preview "~/.vim/plugged/fzf.vim/bin/preview.sh {}" --query '.expand('<cword>')})<CR>

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--disabled', '--query', a:query, '--bind', 'change:reload:'.reload_command, '--preview-window', '+{2}-10,~1', '--delimiter : --nth 4..']}
  let spec = fzf#vim#with_preview(spec, 'right', 'ctrl-/')
  call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
endfunction

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
  let width = float2nr(&columns * 0.86)
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
" add ctrl-k ctrl-j for nerdtree
autocmd FileType nerdtree nnoremap <buffer> <silent> <c-k> 5k
autocmd FileType nerdtree nnoremap <buffer> <silent> <c-j> 5j

" Trigger configuration (Optional) - ultrasnip
let g:UltiSnipsExpandTrigger="<C-9>"

" auto pairs no shortcuts (no meta)
" let g:AutoPairsShortcutToggle=''


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
function! OpenBottomTerminal()
    bo new split
    terminal
endfunction

function! OpenOrReuseBottomTerminal()
    " Get the list of buffers
    redir => bufferlist
    silent exec 'ls'
    redir END
    " Split the list into lines
    let lines = split(bufferlist, "\n")
    " Search for the terminal buffer
    for line in lines
        if line =~ 'term://'
            " Extract the buffer number
            let bufnr = matchstr(line, '^\s*\zs\d\+')
            echo "Reusing terminal"
            " Open the terminal buffer in a horizontal split at the bottom
            exec 'botright split | buffer' bufnr
            return
        endif
    endfor
    " If no terminal buffer is found
    echo "Opening new terminal"
    call OpenBottomTerminal()
endfunction



" exit terminal mode
tnoremap jj <C-\><C-n>
" move between windows in terminal mode
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
" leader - y to open terminal
nnoremap <leader>y :call OpenOrReuseBottomTerminal()<CR>
" D-r insteaf of c-r in terminal mode
tnoremap <expr> <D-r> '<C-\><C-N>"'.nr2char(getchar()).'pi'
" make cursor visible when not in insert mode
exec 'hi! TermCursorNC ctermfg=15 guifg=#fdf6e3 ctermbg=14 guibg=#93a1a1 cterm=NONE gui=NONE'

" autocmd FileType fzf tnoremap <ESC> :q<CR>

" rest split mode (vertical-horizontal)
" let vrc_horizontal_split=1
" It's useful when we don't want to include the response header in the output view but still want the output to be formatted or syntax-highlighted.
let g:vrc_response_default_content_type = 'application/json'
" c-j is used for navigation, change to 
let g:vrc_trigger = '<C-CR>'
let g:vrc_auto_format_response_patterns = {
  \ 'json': 'jq .'
\}


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
" for giffview
nnoremap <leader>gg :DiffviewOpen<CR>
nnoremap <leader>gG :DiffviewClose<CR>
nnoremap <leader>g<c-G> :DiffviewOpen master<CR>




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
command! -nargs=0 Eslint :CocCommand eslint.executeAutofix

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
" Apply Fix all fixable problems.
nmap <leader>qa  <Plug>(coc-fix-current)

" v0.82 additions - switched to custom menu
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
    inoremap <silent><expr> <C-x><C-z> coc#pum#visible() ? coc#pum#stop() : "\<C-x>\<C-z>"
" remap for complete to use tab and <cr>
inoremap <silent><expr> <TAB>
    \ coc#pum#visible() ? coc#pum#next(1):
    \ <SID>check_back_space() ? "\<Tab>" :
    \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <c-space> coc#refresh()

hi CocSearch ctermfg=12 guifg=#18A3FF
hi CocMenuSel ctermbg=109 guibg=#13354A

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

" set nvim title: if its from ~/Development project, set it as the first
" directory name, in big letters. Otherwise, set it as the full path
function! SetNvimTitle(path)
    if bufexists(a:path)
      let home = expand('~')
      let dev_dir = home.'/Development/'

      if a:path =~# '^' . dev_dir
          let dir = substitute(a:path, '^' . dev_dir, '', '')
          let parts = split(dir, '/')
          let title = toupper(parts[0])
          if len(parts) > 1
              let title =  parts[-1].' - '.title
          endif
      else
          let parts = split(a:path, '/')
          let title = parts[-1]
      endif

      return title
    else
      return 'nvim'
    endif
endfunction


" set title to the current dir
if has("nvim")
set title
augroup dirchange
autocmd!
autocmd DirChanged * let &titlestring=SetNvimTitle(v:event['cwd'])
autocmd BufEnter * let &titlestring=SetNvimTitle(expand('%:p'))
augroup END
endif

" blink the cursor
set guicursor=n-ci:iCursor-blinkwait1200-blinkon800-blinkoff600


" Open giyhub file directly from current one
function! OpenGitHubFile()
    function! s:GetDefaultBranch()
        let l:default_branch = systemlist('gh repo view --json defaultBranchRef --jq .defaultBranchRef.name')[0]

        " Extract the branch name from the full reference path
        let l:default_branch = matchstr(l:default_branch, '\w\+$')

        return l:default_branch
    endfunction

    function! s:GetRemoteBranches()
        let l:remote_branches = systemlist('git branch --remote')

        " Process the list to extract branch names
        let l:branch_names = []
        for branch in l:remote_branches
            let l:branch_name = matchstr(branch, 'origin/\zs\w\+$')
            if l:branch_name != ''
                call add(l:branch_names, l:branch_name)
            endif
        endfor

        return l:branch_names
    endfunction

    let l:current_file = expand('%:p')
    let l:git_root_path = systemlist('git rev-parse --show-toplevel')[0]
    
    " Get the remote repository URL
    let l:repo_url = systemlist('git remote get-url origin')[0]
    
    " Remove .git suffix from the URL if present
    let l:repo_url = substitute(l:repo_url, 'git@github.com:', 'https://github.com/', '')
    let l:repo_url = substitute(l:repo_url, '\.git', '', '')

   " Get the current branch
    let l:current_branch = trim(systemlist('git rev-parse --abbrev-ref HEAD')[0])

   " Get the list of remote branches
    let l:remote_branches = s:GetRemoteBranches()
    
    " Check if the current branch exists remotely, otherwise use the default branch
    let l:branch_exists = index(l:remote_branches, l:current_branch) != -1
    if l:branch_exists
        let l:target_branch = l:current_branch
    else
        " Fallback to the default branch
        let l:default_branch = s:GetDefaultBranch()
        let l:target_branch = l:default_branch != '' ? l:default_branch : 'main'
    endif
    
    " Construct the GitHub file URL
    let l:relative_path = substitute(l:current_file, '^' . escape(l:git_root_path, '\'), '', '')
    let l:github_file_url = l:repo_url . '/blob/' . l:target_branch . l:relative_path

    call system('open ' . shellescape(l:github_file_url))
endfunction

nnoremap <leader>gh :call OpenGitHubFile()<CR>



" vim-node-inspect
nnoremap <silent><leader>dd :NodeInspectStart<cr>
nnoremap <silent><leader>dr :NodeInspectRun<cr>
nnoremap <silent><leader>dc :NodeInspectConnect("127.0.0.1:9229")<cr>
nnoremap <silent><leader>ds :NodeInspectStepOver<cr>
nnoremap <silent><leader>di :NodeInspectStepInto<cr>
nnoremap <silent><leader>do :NodeInspectStepOut<cr>
nnoremap <silent><leader>dq :NodeInspectStop<cr>
nnoremap <silent><leader>db :NodeInspectToggleBreakpoint<cr>
nnoremap <silent><leader>da :NodeInspectRemoveAllBreakpoints<cr>
nnoremap <silent><leader>dw :NodeInspectToggleWindow<cr>

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
  if a:encodeDecode == 'e'
    " encode
    execute("%!base64")
  else
    " decode
    execute("%!base64 -d")
  endif
else
" exec on selection
  if a:encodeDecode == 'e'
    " encode
    execute("'<,'>!base64")
  else
    " decode
    execute("'<,'>!base64 -d")
  endif
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
      execute("%! python3 -c 'import sys,urllib.parse; print(urllib.parse.quote(sys.stdin.read()))'")
    else
      execute("%! python3 -c 'import sys,urllib.parse; print(urllib.parse.unquote(sys.stdin.read()))'")
    endif
  else
    " exec on selection
    if a:escape
      execute("'<,'>!python3 -c 'import sys,urllib.parse; print(urllib.parse.quote(sys.stdin.read()))'")
    else
      execute("'<,'>!python3 -c 'import sys,urllib.parse; print(urllib.parse.unquote(sys.stdin.read()))'")
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
"nnoremap <leader>ff <cmd>Telescope find_files<cr>
"nnoremap <leader>fg <cmd>Telescope live_grep<cr>
"nnoremap <leader>fb <cmd>Telescope buffers<cr>
"nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" emmet additiona snippets: need to create
" let g:user_emmet_settings = json_decode(join(readfile(expand('~/.config/emmet/snippets.json')), "\n"))


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
    normal csw"
  endif
endfunction

" vim-surround toggle quote helper function
nnoremap <c-'> :call ToggleQuotes()<CR>

" dadbod/dadbod-ui
let g:db_ui_save_location = '~/tmp/vimfiles'
let g:db_ui_use_nerd_fonts = 1
let g:db_ui_win_position = 'right'


" javascript tooling
nnoremap <c-p> :Prettier<CR>
nnoremap <c-0> :Eslint<CR>
nnoremap <c-a> <Plug>(coc-codeaction)

" increase/decrese gui font
" idea from https://www.vim.org/scripts/script.php?script_id=2321
function! UpdateFontSize(amount)
  if exists(':GuiFont')
    let font = execute('GuiFont')
    let fontSize = substitute(font, '^.*:h\([^:]*\).*$', '\1', '')
    let fontSize += a:amount
    let newFont = trim(substitute(font, ':h\([^:]*\)', ':h' . fontSize, ''))
    execute('GuiFont '.newFont)
  endif

  "execute("set guifont=".newFont)
endfunction

function! DefaultFontSize()
  if exists(':GuiFont')
    let font = execute('GuiFont')
    let fontSize = 13 " sorry
    let newFont = trim(substitute(font, ':h\([^:]*\)', ':h' . fontSize, ''))

    execute('GuiFont '.newFont)
  endif

  " execute("set guifont=".newFont)
endfunction

nnoremap <D-=> :call UpdateFontSize(1)<CR>
nnoremap <D--> :call UpdateFontSize(-1)<CR>
nnoremap <D-0> :call DefaultFontSize()<CR>


" copy filename to clipboard
nnoremap <Leader>c :let @+=@%<CR>

" execute current line or current selection in shell and get output
nnoremap _X  :put =system(getline('.'))<cr>
vnoremap _X  :<C-U>'>put =system(join(getline('''<','''>'),\"\n\").\"\n\")<cr>


" copilot, use shift+tab instead of tab
imap <silent><script><expr> <s-tab> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

" codeium, use shift+tab instead of tab
"let g:codeium_no_map_tab = 1
"imap <script><silent><nowait><expr> <S-tab> codeium#Accept()

" global status line, mvim only
if has("nvim")
  set laststatus=3
endif

" Zoom / Restore window.
function! s:ZoomToggle() abort
    if exists('t:zoomed') && t:zoomed
        execute t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction
command! ZoomToggle call s:ZoomToggle()
nnoremap <silent> <C-A> :ZoomToggle<CR>


" Enter in normal mode breaks(splits) the line
:nnoremap <Enter> i<CR><ESC>

" vim-rest-console - convert curl to vrc
function! ConvertCurlToVRC() range
  " Get the selected lines
  let lines = getline(a:firstline, a:lastline)
  let output = []
  let url = ''
  let headers = []
  let method_path = 'GET'  " Default method

  " Process each line
  for line in lines
    " Extract URL from the curl command line
    if line =~# "^curl '"
      let url = matchstr(line, "curl '\\zs[^']*\\ze'")
      " Extract path for the GET line
      let path = substitute(url, '^https\?://[^/]*', '', '')
      let method_path = 'GET ' . path
      continue
    endif
    
    " Process header lines
    if line =~# '^-H'
      " Remove -H and surrounding quotes, trim whitespace
      let header = substitute(line, '^-H\s*[''"]\(.*\)[''"]\s*$', '\1', '')
      " Split into key-value pair
      let parts = split(header, ':', 1)
      if len(parts) >= 2
        let key = trim(parts[0])
        let value = trim(join(parts[1:], ':'))
        call add(headers, key . ': ' . value)
      endif
    endif
  endfor

  " Construct the output
  " First line is the base URL
  let base_url = substitute(url, '\(https\?://[^/]*\).*', '\1', '')
  call add(output, base_url)
  call add(output, '')

  " Add all headers
  call extend(output, headers)
  call add(output, '')

  " Add the method and path
  call add(output, method_path)

  " Replace the selected lines with our new format
  execute a:firstline . ',' . a:lastline . 'delete _'
  call append(a:firstline - 1, output)
endfunction

" Map it to a command you can use after selecting text
command! -range CurlToVRC <line1>,<line2>call ConvertCurlToVRC()
vnoremap <leader>ct :CurlToVRC<CR>


" whisper.nvim - text to speech
inoremap <C-G>  <C-O>:!whisper.nvim<CR><C-O>:let @a = system("cat /tmp/whisper.nvim \| tail -n 1 \| xargs -0 \| tr -d '\\n' \| sed -e 's/^[[:space:]]*//'")<CR><C-R>a
nnoremap <C-G>       :!whisper.nvim<CR>:let @a = system("cat /tmp/whisper.nvim \| tail -n 1 \| xargs -0 \| tr -d '\\n' \| sed -e 's/^[[:space:]]*//'")<CR>"ap
vnoremap <C-G> c<C-O>:!whisper.nvim<CR><C-O>:let @a = system("cat /tmp/whisper.nvim \| tail -n 1 \| xargs -0 \| tr -d '\\n' \| sed -e 's/^[[:space:]]*//'")<CR><C-R>a


" image paste
nnoremap <leader>p :PasteImage<CR>


" Specify a direcory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.vim/plugged')


" Make sure you use single quotes
Plug 'tpope/vim-fugitive'
" commit browser
Plug 'junegunn/gv.vim'
" show changes
Plug 'airblade/vim-gitgutter'
" diff alternative (two repos), used for prs - replaced merginal
Plug 'nvim-lua/plenary.nvim'
Plug 'sindrets/diffview.nvim'

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
" fzf-coc integration
"Plug 'antoinemadec/coc-fzf'

" nerdtree an dplugins
Plug 'scrooloose/nerdtree'
" this is the original highlight plugin, throws errors w new nvim
"Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" this one fixed it
Plug 'johnstef99/vim-nerdtree-syntax-highlight'

Plug 'Xuyuanp/nerdtree-git-plugin'


" color schemes
" Plug 'dracula/vim', { 'as': 'dracula' }
" Plug 'KeitaNakamura/neodark.vim'
" Plug 'joshdick/onedark.vim'
"Plug 'wuelnerdotexe/vim-enfocado'
"Plug 'drewtempelmeyer/palenight.vim'
" Plug 'mhartington/oceanic-next'
"Plug 'folke/tokyonight.nvim'
"Plug 'cocopon/iceberg.vim'
" Plug 'jacoborus/tender.vim'
" Plug 'ayu-theme/ayu-vim'
if has("nvim")
  Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
endif

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
Plug 'maksimr/vim-jsbeautify'

" as is (colortheme)
" Plug 'NLKNguyen/papercolor-theme'


" static code analysis
" Plug 'vim-syntastic/syntastic'

" rest console
Plug 'diepm/vim-rest-console'

" auto idention detectin
Plug 'tpope/vim-sleuth'

" database if
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'

"pgp
Plug 'jamessan/vim-gnupg'

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

" git messanger
Plug 'rhysd/git-messenger.vim' 

"""""" Code eompletion engines
" co pilot
" disabled: no license
Plug 'github/copilot.vim'

" avante.nvim
Plug 'stevearc/dressing.nvim'
" Plug 'nvim-lua/plenary.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'MeanderingProgrammer/render-markdown.nvim'

" Optional deps
Plug 'hrsh7th/nvim-cmp'
Plug 'nvim-tree/nvim-web-devicons' "or Plug 'echasnovski/mini.icons'
Plug 'HakonHarnes/img-clip.nvim'
Plug 'zbirenbaum/copilot.lua'

" Yay, pass source=true if you want to build from source
Plug 'yetone/avante.nvim', { 'branch': 'main', 'do': 'make' }

" co pilot chat
" if has("nvim")
  "" Plug 'nvim-lua/plenary.nvim' " already installed
  " Plug 'CopilotC-Nvim/CopilotChat.nvim'
" endif

""if has("nvim")
  " cody
  ""Plug 'sourcegraph/sg.nvim', { 'do': 'nvim -l build/init.lua' }
  " Required for various utilities - note this is already added above
  " Plug 'nvim-lua/plenary.nvim'
  " Required if you want to use some of the search functionality
  "Plug 'nvim-telescope/telescope.nvim'Plug 'nvim-telescope/telescope.nvim'
""endif
" not used at nsure

"if has("nvim")
"  Plug 'Exafunction/codeium.vim', { 'branch': 'main' }
"endif
" Plug 'huggingface/llm.nvim'

"""""" End of code completion engines



if has("nvim")
  " treesitting
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/playground'
  " telescope. fzf alike
  "Plug 'nvim-lua/plenary.nvim " penary is already added used by diffview

  " line idention, nvim only
  Plug 'lukas-reineke/indent-blankline.nvim'
endif

" Initialize pugin system
call plug#end()





" nvim specific configs
if has("nvim")

lua << EOF
  require("img-clip").setup({});
EOF

lua << EOF

  -- indent-blankline
  require("ibl").setup() 

EOF

" highlight yank, neovim-only
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=300}
augroup END



"nvim treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"javascript", "css", "scss", "typescript", "rust"}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = {}, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = {},  -- list of language that will be disabled
    -- Setting his to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be: a list of languages
    additional_vim_regex_highlighting = false,
  },
}

-- llm nvim, local ollama
--[[
require('llm').setup({
  backend = "ollama",
  model = "starcoder:7b",
  url = "http://localhost:11434/api/generate",
  accept_keymap = "<S-Tab>",
  dismiss_keymap = "<c-Tab>",
  -- cf https://github.com/ollama/ollama/blob/main/docs/api.md#parameters
  request_body = {
    -- Modelfile options for the model you use
    options = {
      temperature = 0.2,
      top_p = 0.95,
    }
  },
   -- set this if the model supports fill in the middle
  fim = {
    enabled = true,
    prefix = "<fim_prefix>",
    middle = "<fim_middle>",
    suffix = "<fim_suffix>",
  }
})
]]

EOF


" Avante.nvim configuration
lua << EOF
require('avante_lib').load()
require('avante').setup({
  provider = "gemini", -- Recommend using Claude
  gemini = {
    endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
    model = "gemini-2.5-pro-exp-03-25",
    timeout = 30000, -- Timeout in milliseconds
    temperature = 0,
    max_tokens = 8192,
  },
  dual_boost = {
    enabled = false,
    first_provider = "openai",
    second_provider = "claude",
    prompt = "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
    timeout = 60000, -- Timeout in milliseconds
  },
  behaviour = {
    auto_suggestions = false, -- Experimental stage
    auto_set_highlight_group = true,
    auto_set_keymaps = true,
    auto_apply_diff_after_generation = false,
    support_paste_from_clipboard = false,
    minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
    enable_token_counting = true, -- Whether to enable token counting. Default to true.
  },
  mappings = {
    diff = {
      ours = "co",
      theirs = "ct",
      all_theirs = "ca",
      both = "cb",
      cursor = "cc",
      next = "]x",
      prev = "[x",
    },
    suggestion = {
      accept = "<M-l>",
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
    jump = {
      next = "]]",
      prev = "[[",
    },
    submit = {
      normal = "<CR>",
      insert = "<C-s>",
    },
    sidebar = {
      apply_all = "A",
      apply_cursor = "a",
      switch_windows = "<Tab>",
      reverse_switch_windows = "<S-Tab>",
    },
  },
  hints = { enabled = true },
  windows = {
    position = "right", -- the position of the sidebar
    wrap = true, -- similar to vim.o.wrap
    width = 30, -- default % based on available width
    sidebar_header = {
      enabled = true, -- true, false to enable/disable the header
      align = "center", -- left, center, right for title
      rounded = true,
    },
    input = {
      prefix = "> ",
      height = 8, -- Height of the input window in vertical layout
    },
    edit = {
      border = "rounded",
      start_insert = true, -- Start insert mode when opening the edit window
    },
    ask = {
      floating = false, -- Open the 'AvanteAsk' prompt in a floating window
      start_insert = true, -- Start insert mode when opening the ask window
      border = "rounded",
      focus_on_apply = "ours", -- which diff to focus after applying
    },
  },
  highlights = {
    diff = {
      current = "DiffText",
      incoming = "DiffAdd",
    },
  },
  diff = {
    autojump = true,
    list_opener = "copen",
    override_timeoutlen = 500,
  },
  suggestion = {
    debounce = 600,
    throttle = 600,
  },
})
EOF

endif "if has("nvim")

" color scheme
"let g:oceanic_next_terminal_bold = 1
"let g:oceanic_next_terminal_italic = 1
if (has("termguicolors"))
  set termguicolors
endif
"colorscheme OceanicNext
"let g:airline_theme = "oceanicnext"

"colorscheme tokyonight-night
"colorscheme tokyonight-storm
"colorscheme tokyonight-day
"colorscheme tokyonight-moon
"colorscheme iceberg
"colorscheme tender
"let ayucolor = 'dark' " / light / mirage
"colorscheme ayu
"
" colorschemes: catppuccin catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
if has("nvim")
  colorscheme catppuccin-mocha
endif

" Cody setup. needs to be late
"lua <<EOF
  "require('sg').setup({
    "enable_cody = true,
  "})
"EOF

" load db definition
try 
  source ~/.config/local-vim/.dbs.vim
catch
  " will silently ignore file-not-found error
endtry 
