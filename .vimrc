set nocompatible              " be iMproved, required
filetype off                  " required

" enable matchit
runtime macros/matchit.vim

" set the runtime path to include Vundle and initialize
if has("win32")
    set rtp+=$HOME/vimfiles/bundle/Vundle.vim
    call vundle#begin('$HOME/vimfiles/bundle/')
else
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
endif
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'scrooloose/nerdtree'

Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

if has("win32") == 0
    Plugin 'Valloric/YouCompleteMe'
    Plugin 'christoomey/vim-tmux-navigator'
    if has("nvim")
        Plugin 'arakashic/chromatica.nvim'
        Plugin 'numirias/semshi'
    else
        Plugin 'jeaye/color_coded'
    endif
    Plugin 'rdnetto/YCM-Generator'
    Plugin 'vim-syntastic/syntastic'
endif

" Plugin 'taglist.vim'
" Bundle 'craigemery/vim-autotag'
Plugin 'ludovicchabant/vim-gutentags'
Plugin 'majutsushi/tagbar'

Plugin 'cyanjc321/Smart-Tabs'
Plugin 'easymotion/vim-easymotion'
Plugin 'godlygeek/tabular'
Plugin 'jiangmiao/auto-pairs'
Plugin 'rhysd/vim-clang-format'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'tpope/vim-speeddating'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-dispatch'

" Language support
Plugin 'OrangeT/vim-csharp'
Plugin 'gabrielelana/vim-markdown'
Plugin 'jceb/vim-orgmode'
Plugin 'rhysd/vim-grammarous'
Plugin 'vhda/verilog_systemverilog.vim'

" Track the engine.
Plugin 'SirVer/ultisnips'
" Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'

" Color schemes
if has("gui_running") == 0
    Plugin 'CSApprox'
endif
Plugin 'flazz/vim-colorschemes'
"Plugin 'rafi/awesome-vim-colorschemes'
"Plugin 'euclio/vim-nocturne'
"Plugin 'nightsense/office'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

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
" syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_python_exec = 'python3'

"##############################################################################################
" ultisnips settings
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger = "<c-e>"
let g:UltiSnipsJumpForwardTrigger = "<c-b>"
let g:UltiSnipsJumpBackwardTrigger = "<c-v>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit = "vertical"

"##############################################################################################
" YouCompleteMe settings
let g:ycm_key_list_select_completion = []
let g:ycm_key_list_previous_completion = []
let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
let g:ycm_autoclose_preview_window_after_completion = 1
nnoremap <leader>gt :YcmCompleter GoTo<CR>
nnoremap <leader>gi :YcmCompleter GoToInclude<CR>
nnoremap <leader>gc :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
nnoremap <leader>gt :YcmCompleter GetType<CR>
nnoremap <leader>gp :YcmCompleter GetParent<CR>
nnoremap <leader>gd :YcmCompleter GetDoc<CR>
nnoremap <leader>fi :YcmCompleter FixIt<CR>

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
        let g:AutoPairsShortcutToggle = "<ESC>p"
        let g:AutoPairsShortcutFastWrap = "<ESC>w"
        let g:AutoPairsShortcutJump = "<ESC>j"
        let g:AutoPairsShortcutBackInsert = "<ESC>b"
    endif
endif
"##############################################################################################
" chromatica, required llvm-config in $PATH
" set path to file according to os, required to enable logging for now
if has("macunix")
    let g:chromatica#libclang_path = substitute(system('llvm-config --libdir'), '\n', '/libclang.dylib', '')
else
    let g:chromatica#libclang_path = substitute(system('llvm-config --libdir'), '\n', '/libclang.so', '')
endif
let g:chromatica#global_args = ['-isystem'.substitute(system('llvm-config --includedir'), '\n', '', '')]
let g:chromatica#enable_at_startup = 1

"##############################################################################################
" miscellaneous
colorscheme gruvbox

syntax enable
set background=dark
set exrc
set secure
set hlsearch
set number
set colorcolumn=110
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

