" generic setting "{{{
nnoremap ,l <C-w>L
nnoremap ,j <C-w>J
nnoremap ,k <C-w>K
nnoremap ,h <C-w>H
" setting open vimrc "{{{
command VI :tabnew /root/.config/nvim/init.vim
command DE :tabnew /root/.config/nvim/dein.toml
command SO :so /root/.config/nvim/init.vim
"}}}
" setting encoding"{{{
set encoding=utf-8
set fileencodings=utf-8,euc-jp,sjis
set fileformats=unix,dos
"}}}
nnoremap j gj
nnoremap k gk
" setting search"{{{
nnoremap * *Nzz
set hlsearch
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>
"}}}
" setting cursole type"{{{
if has('unix')
	let &t_ti.="\e[1 q"
	let &t_SI.="\e[5 q"
	let &t_EI.="\e[1 q"
	let &t_te.="\e[0 q"
endif
"}}}
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=0
set ttimeoutlen=50
" setting move mode"{{{
inoremap mm <ESC>
nnoremap mm <ESC>
vnoremap mm <ESC>
cnoremap mm <ESC>
"}}}
" setting guioption"{{{
set guioptions-=T
set guioptions-=m
"}}}
" setting wild menu"{{{
set wildmenu
set wildmode=longest:full,full
"}}}
syntax enable
set background=dark
set t_Co=256
set nobackup
set autoindent
set nu

set virtualedit=all
set switchbuf=useopen
set matchpairs& matchpairs+=<:>

" tail -> next head/head -> prev tail
set whichwrap=b,s,h,l,<,>,[,],~
" cursor highlight
set cursorline
set title

" setting change window width"{{{
nnoremap <Left> <C-w><<CR>
nnoremap <Right> <C-w>><CR>
nnoremap <Up> <C-w>+
nnoremap <Down> <C-w>-
"}}}
" setting key mapping cmd mode"{{{
cnoremap <C-a> <Home>
cnoremap <C-b> <left>
cnoremap <C-f> <right>
cnoremap <C-d> <Del>
cnoremap <C-e> <End>
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>
cnoremap <Space>p <C-r>0
"}}}
" setting gui font"{{{
if has('win64')
	set guifont=Myrica\ M:h11
endif
"}}}
set iminsert=0
" setting specific word"{{{
set listchars=tab:»-,trail:_,eol:↲,extends:»,precedes:«,nbsp:%
nnoremap <silent><C-l> :call CodeReview()<CR>
"}}}
nnoremap <S-y> y$
" setting move easy window"{{{
nnoremap <Space>w <C-w>
"}}}
vnoremap * "zy:let @/ = @z<CR>n
" highlighting tail space"{{{
augroup HighlightTrailingSpaces
	" autocmd!
	" autocmd VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
	" autocmd VimEnter,WinEnter * match TrailingSpaces /\s\+$/
augroup END
"}}}
nnoremap <S-s> :%s///g<C-e><left><left><left>
" set lines=53
" set columns=97
" winpos -15 0
set autochdir
set iminsert=0
set imsearch=-1
nnoremap <Space>l gt
nnoremap <Space>h gT
nnoremap tn :tabnew<CR>
nnoremap to :tabonly<CR>
"}}}


" ---------------------------neovim----------------------------
if !&compatible
      set nocompatible
  endif

" reset augroup
augroup MyAutoCmd
    autocmd!
augroup END

" dein settings
" dein自体の自動インストール
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
    call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath
" プラグイン読み込み＆キャッシュ作成
let s:toml_file = fnamemodify(expand('<sfile>'), ':h').'/dein.toml'
if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)
    call dein#load_toml(s:toml_file)
    call dein#end()
    call dein#save_state()
endif
" 不足プラグインの自動インストール
if has('vim_starting') && dein#check_install()
    call dein#install()
endif



" Git conds
command! -nargs=+ Tg :T git <args>

"set termguicolors
set background=dark
set t_Co=256
" colorscheme lucius
colorscheme tender
syntax on

let g:python_host_prog = substitute(system('which python3.6'), "\n", "", "")
let g:python3_host_prog = substitute(system('which python3.6'), "\n", "", "")

" settings deoplete
set completeopt=menuone


" settings jedi
" let g:jedi#completions_command = "<C-Space>"
" let g:jedi#rename_command = "[jedi]r"
" let g:jedi#popup_select_first = 0
" let g:jedi#popup_on_dot = 0
" let g:jedi#show_call_signatures = 1
" let g:jedi#show_call_signatures_delay = 10
nnoremap <C-g> :call jedi#goto_assignments()<CR>
nnoremap <C-k> :call jedi#show_documentation()<CR>
nnoremap <C-u> :call jedi#usages()<CR>
nnoremap <C-j> :call jedi#goto_definitions()<CR>

" settings quickfix
nnoremap <Space>p :cp<cr>
nnoremap <Space>n :cn<cr>
