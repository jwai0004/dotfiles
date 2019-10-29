"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim-Plug
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Install vim-plug if not already installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Ale for linting
Plug 'dense-analysis/ale'

" COC for autocomplete and LSP
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Rainbow Brackets
Plug 'junegunn/rainbow_parentheses.vim'

" Unimpaired Keybindings
Plug 'tpope/vim-unimpaired'

" Enable plugin command repeating with .
Plug 'tpope/vim-repeat'

" Simple commenting and uncommenting
Plug 'tpope/vim-commentary'

" Add and delete brackets in pairs
Plug 'tmsvg/pear-tree'

" Git wrapper
Plug 'tpope/vim-fugitive'

" Add bindings for surrounding objects
Plug 'tpope/vim-surround'

" Airline statusline and themes
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Better netrw
Plug 'jeetsukumaran/vim-filebeagle'

" FZF Integration
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Language support
Plug 'sheerun/vim-polyglot'

" Latex Integration
Plug 'lervag/vimtex'

" Python Black command support
Plug 'psf/black'

" Tmux pane navigation
Plug 'christoomey/vim-tmux-navigator'

" Tmuxairline integration
Plug 'edkolev/tmuxline.vim'

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ALE
" Enable pyflakes linter for python and disable asm linting
let g:ale_linters = {'python': ['pyflakes'], 'asm' : []}
call ale#Set('python_pyflakes_executable', 'pyflakes')

" COC 
" Let ALE handle linting
call coc#config('diagnostic', {'displayByAle' : 'true'})

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
" Additional config required to not conflict with pear-tree
imap <expr> <CR> !pumvisible() ? "\<Plug>(PearTreeExpand)" : 
            \complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Keybind for goto definition
nmap <silent> gd <Plug>(coc-definition)

" Keybind for renaming current symbol
nmap <leader>rn <Plug>(coc-rename)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" COC Extensions
" 10000 most common words
" Vimtex support
" Snippet completions
" Python support
call coc#add_extension(
        \'coc-word',
        \'coc-vimtex',
        \'coc-snippets',
        \'coc-python',
        \)

" Disable python linting
call coc#config('python.linting', {'enabled': 'false'})

" Rainbow Parens enable, use for all bracket types and blacklist white
au VimEnter * RainbowParentheses
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]
let g:rainbow#blacklist = [225]

" Airline theme and font
let g:airline_powerline_fonts = 1
let g:airline_theme = 'modified_murmur'

" Airline buffers and tabs
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#buffer_min_count = 2

" FZF bindings
" <C-P> for searching for line in directory with RipGrep
nnoremap <c-p> :Rg<cr>

" Disable whitespace highlighting from vim-polyglot
let g:python_highlight_space_errors = 0

" Disable Latex-box from vim-polyglot and use vimtex instead
let g:polyglot_disabled = ['latex']

" Fix CSV key binding conflict with leader
let g:csv_nomap_space = 1

" Use tectonic in vimtex
let g:vimtex_compiler_method = 'tectonic'
let g:vimtex_fold_enabled = 0
let g:tex_conceal = ""

" Compile on save
autocmd FileType tex autocmd BufWritePre <buffer> :VimtexCompile

" Run black with <leader>bb
nnoremap <leader>bb :Black<CR>

" Don't auto update tmuxline when opening vim to avoid overwriting snapshot
let g:airline#extensions#tmuxline#enabled = 0

" Lots of settings from: https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set number of history lines
set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on

" Auto read modified files
set autoread

" Keep indentation level
set autoindent

" Set leader to space
map <Space> <leader>

" Fast saving with <leader> w
nmap <leader>w :w!<cr>

" Rebind Wq to wq
command! Wq wq

" Rebind Q to q
command! Q q

" :W for sudo save
command W w !sudo tee % > /dev/null

" Enable mouse support
set mouse=a

" Sensible folding
set foldmethod=indent
set foldlevel=99
nnoremap <leader>z za

" Refreshes some plugins, default is 4000ms 
set updatetime=300

" Use persistent undo history, creating dir if it doesn't exist
if !isdirectory("/tmp/.vim-undo-dir")
  call mkdir("/tmp/.vim-undo-dir", "", 0700)
endif
set undodir=/tmp/.vim-undo-dir
set undofile

" Delete comment character when joining commented lines
set formatoptions+=j

" Faster timeout between key presses
if !has('nvim') && &ttimeoutlen == -1
  set ttimeout
  set ttimeoutlen=200
endif

" Improves performance in files with long lines
if &synmaxcol == 3000
  set synmaxcol=500
endif

" Load matchit.vim if user hasn't installed a newer version
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

" Fix @ symbols at end of file if line is wrapped
set display+=lastline


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Toggle ColorColumn at 88 chars
" Bound to <leader>cc
nnoremap <silent> <leader>cc :execute "set colorcolumn=" . (&colorcolumn == "" ? "88" : "")<CR>

" Keep 7 lines on screen
set scrolloff=7

" Enable wild menu
set wildmode=longest:full,full
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
  set wildignore+=.git\*,.hg\*,.svn\*
else
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" Always show current position
set ruler

" Height of the command bar
set cmdheight=2

" Hide buffer when its abandoned
set hid

" Normal backspace
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase
set smartcase

" Highlight search results
set hlsearch

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Incremental search
set incsearch

" Improve performance with lazy redraw
set lazyredraw

" For regular expressions
set magic

" Highlight matching brackets and blink for 2 tenths of a second
set showmatch
set mat=2

" No sounds
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Enable line numbers (absolute on current line, relative elsewhere)
set number
set relativenumber

" Set cursor by mode from https://vim.fandom.com/wiki/Change_cursor_shape_in_different_modes
" Had issues with cursor disappearing
" set guicursor&

if has("autocmd")
  au VimEnter,InsertLeave * silent execute '!echo -ne "\e[1 q"' | redraw!
  au InsertEnter,InsertChange *
        \ if v:insertmode == 'i' |
        \   silent execute '!echo -ne "\e[5 q"' | redraw! |
        \ elseif v:insertmode == 'r' |
        \   silent execute '!echo -ne "\e[3 q"' | redraw! |
        \ endif
  au VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable
syntax on

" Set .asm files to use MIPS syntax highlighting
" Based on https://stackoverflow.com/questions/11666170/persistent-set-syntax-for-a-given-filetype
" Uses syntax file from https://github.com/harenome/vim-mipssyntax put into vim-polyglot /syntax
au BufRead,BufNewFile *.asm set filetype=mips 

" Enable 256 colors palette
set t_Co=256

" Set colors to molokai transparent from https://github.com/Znuff/molokai
try
  colorscheme molokaiTransparent
catch
endtry

" Set UTF-8 as standard enconding
set encoding=utf-8


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

" Delete trailing white space on save, useful for some filetypes
fun! CleanExtraSpaces()
  let save_cursor = getpos(".")
  let old_query = getreg('/')
  silent! %s/\s\+$//e
  call setpos('.', save_cursor)
  call setreg('/', old_query)
endfun

if has("autocmd")
  autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

function! VisualSelection(direction, extra_filter) range
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", "\\/.*'$^~[]")
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction == 'gv'
    call CmdLine("Ack '" . l:pattern . "' " )
  elseif a:direction == 'replace'
    call CmdLine("%s" . '/'. l:pattern . '/')
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" New bindings to open splits
map <leader>\ :vsplit<cr>
map <leader>- :split<cr>

" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

" Close all the buffers
map <leader>ba :bufdo bd<cr>

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
  let l:currentBufNum = bufnr("%")
  let l:alternateBufNum = bufnr("#")

  if buflisted(l:alternateBufNum)
    buffer #
  else
    bnext
  endif

  if bufnr("%") == l:currentBufNum
    new
  endif

  if buflisted(l:currentBufNum)
    execute("bdelete! ".l:currentBufNum)
  endif
endfunction

function! CmdLine(str)
  call feedkeys(":" . a:str)
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

" Create function to trim whitespace
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/s\s\+$//e
    call winrestview(l:save)
endfun

command! TrimWhitespace call TrimWhitespace()
