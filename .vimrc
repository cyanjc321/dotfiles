" be iMproved, required
set nocompatible

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
Plug 'majutsushi/tagbar'
Plug 'ludovicchabant/vim-gutentags'
Plug 'skywind3000/gutentags_plus'
"Plug 'taglist.vim'
"Plug 'craigemery/vim-autotag'

" Language support
"Plug 'vim-syntastic/syntastic'
Plug 'neoclide/coc.nvim'
Plug 'jackguo380/vim-lsp-cxx-highlight'
"Plug 'rhysd/vim-clang-format'
if has("nvim")
    Plug 'numirias/semshi'
endif
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
" gutentags/gutentags_plus
let g:gutentags_modules = ['ctags', 'gtags_cscope']
let g:gutentags_cache_dir = expand('~/.cache/tags')
let g:gutentags_plus_switch = 1

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
" coc

set hidden
set nobackup
set nowritebackup
set updatetime=300
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if !has("nvim")
    if has("patch-8.1.1564")
      " Recently vim can merge signcolumn and number column into one
      set signcolumn=number
    else
      set signcolumn=yes
    endif
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

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

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

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

