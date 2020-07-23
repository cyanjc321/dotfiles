set nocompatible              " be iMproved, required

" enable matchit
runtime macros/matchit.vim

call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'scrooloose/nerdtree'

Plug 'christoomey/vim-tmux-navigator'
Plug 'cyanjc321/Smart-Tabs'
Plug 'easymotion/vim-easymotion'
Plug 'godlygeek/tabular'
Plug 'jiangmiao/auto-pairs'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dispatch'
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'
"Plug 'taglist.vim'
"Plug 'craigemery/vim-autotag'

" Language support
"Plug 'vim-syntastic/syntastic'
Plug 'neoclide/coc.nvim'
Plug 'jackguo380/vim-lsp-cxx-highlight'
Plug 'rhysd/vim-clang-format'
Plug 'numirias/semshi'
Plug 'OrangeT/vim-csharp'
Plug 'gabrielelana/vim-markdown'
Plug 'jceb/vim-orgmode'
Plug 'rhysd/vim-grammarous'
Plug 'vhda/verilog_systemverilog.vim'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'godlygeek/csapprox'

Plug 'flazz/vim-colorschemes'
"Plug 'rafi/awesome-vim-colorschemes'
"Plug 'euclio/vim-nocturne'
"Plug 'nightsense/office'
call plug#end()

"##############################################################################################
" Indentation setting
set expandtab
set copyindent
set preserveindent
set softtabstop=0
set shiftwidth=4
set tabstop=4
set cindent                 " smart indenting for c-like code
set cino=b1,g0,N-s,t0,(0,W4 " see :h cinoptions-value

"##############################################################################################
" ultisnips settings
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger = "<c-e>"
let g:UltiSnipsJumpForwardTrigger = "<c-b>"
let g:UltiSnipsJumpBackwardTrigger = "<c-v>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit = "vertical"

"##############################################################################################
" vim airline
set laststatus=2  " always on airline bar
let g:airline_powerline_fonts = 1

"##############################################################################################
" verilog_systemverilog
let g:verilog_disable_indent_lst = "module,interface,preproc,eos"
let g:verilog_syntax_fold_lst = "comment,instance,function,task,block_named"

autocmd FileType verilog_systemverilog compiler! vcs

"##############################################################################################
" grammarous
let g:grammarous#languagetool_cmd = 'languagetool'
let g:grammarous#use_vim_spelllang = 1

"##############################################################################################
" tagbar
nnoremap <F8> :TagbarToggle<CR>

"##############################################################################################
" auto-pairs
let g:AutoPairsFlyMode = 1
if has("macunix")
    let g:AutoPairsShortcutToggle = "π" "<M-p>
    let g:AutoPairsShortcutFastWrap = "∑" "<M-w>
    let g:AutoPairsShortcutJump = "∆" "<M-j>
    let g:AutoPairsShortcutBackInsert = "∫" "<M-b>
else
    if has("gui_running") || has("nvim")
        let g:AutoPairsShortcutToggle = "<M-p>"
        let g:AutoPairsShortcutFastWrap = "<M-w>"
        let g:AutoPairsShortcutJump = "<M-j>"
        let g:AutoPairsShortcutBackInsert = "<M-b>"
    else
        " assume console issues escape sequence
        " note this result in slow <esc> switching between insert and normal mode
        "let g:AutoPairsShortcutToggle = "<ESC>p"
        "let g:AutoPairsShortcutFastWrap = "<ESC>w"
        "let g:AutoPairsShortcutJump = "<ESC>j"
        "let g:AutoPairsShortcutBackInsert = "<ESC>b"
    endif
endif

"##############################################################################################
" miscellaneous
colorscheme gruvbox

syntax enable
set background=dark
set exrc
set secure
set hlsearch
set number
set colorcolumn=80
set ignorecase      " case insensitive searching
set smartcase       " but become case sensitive when uppercase characters are typed
set noshowmode      " dont show (-- INSERT --) at the bottom
set backspace=indent,eol,start
set cmdheight=2     " number of line to use for command-line
set tags=./tags;/   " look for tags in current dir and every dir above until root

if has("gui_gtk")
    set guifont=hack\ 9
elseif has("win32")
    set guifont=Consolas:h10
else
    set guifont=Hack:h9
endif

set guioptions-=T   " remove toolbar
set guioptions-=l   " remove left-hand scrollbar
set guioptions-=L   " remove left-hand scrollbar
set guioptions-=r   " remove right-hand scrollbar
set guioptions-=R   " remove right-hand scrollbar
set guioptions-=m   " remove menu bar
set guioptions-=M   " stop source $VIMRUNTIME/menu.vim

" key remap
" split navigation
nnoremap <C-h> :wincmd h<CR>
nnoremap <C-j> :wincmd j<CR>
nnoremap <C-k> :wincmd k<CR>
nnoremap <C-l> :wincmd l<CR>

" remove trailing space for some languages
autocmd FileType c,cpp,java,php,verilog_systemverilog,python,ruby,sh,zsh,cs autocmd BufWritePre <buffer> %s/\s\+$//e

" word break
autocmd FileType txt,tex set linebreak

