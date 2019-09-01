" generic setting "{{{
" set spell
set spelllang=en,cjk
nnoremap ,l <C-w>L
nnoremap ,j <C-w>J
nnoremap ,k <C-w>K
nnoremap ,h <C-w>H
" setting open vimrc "{{{
command VI :tab drop ~/.config/nvim/init.vim
command DE :tab drop ~/.config/nvim/dein.toml
command SO :so ~/.config/nvim/init.vim
"}}}
" setting encoding"{{{
set encoding=utf-8
set fileencodings=utf-8,euc-jp,sjis
set fileformats=unix,dos
"}}}
nnoremap j gj
nnoremap k gk
nnoremap v <c-v>
vnoremap / <esc>/\%V
nnoremap <c-b> <c-^>
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
inoremap jj <ESC>
" nnoremap jj <ESC>
vnoremap mm <ESC>
cnoremap jj <ESC>
tnoremap <silent> jj <c-\><c-n>
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
cnoremap <Space>; <C-r>0
"}}}
" setting gui font"{{{
if has('win64')
	set guifont=Myrica\ M:h11
endif
"}}}
set iminsert=0
" setting specific word"{{{
set listchars=tab:>.,trail:_,eol:$,extends:>,precedes:<,nbsp:%
nnoremap <silent><C-l> :set list!<CR>
"nnoremap <silent><C-l> :call CodeReview()<CR>
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
" set lines=53
" set columns=97
" winpos -15 0
set autochdir
set iminsert=0
set imsearch=-1
nnoremap <Space>l gt
nnoremap <Space>h gT
nnoremap tm :tabm 
nnoremap tn :tabnew<CR>
nnoremap to :tabonly<CR>
nnoremap tp :tab sp<CR>
nnoremap tl :+tabm<cr>
nnoremap th :-tabm<cr> 
nnoremap <Space>x :call My_tabclose()<CR>
nnoremap <Space>q :call My_tabclose()<CR>
nnoremap <Space>a gg<S-v><S-g>
nnoremap <c-c> :only<CR>
function! My_tabclose()
  :tabclose
  :tabprevious
endfunction
nnoremap <silent>vp gv
nnoremap dif :windo diffthis<cr>
nnoremap dio :diffoff<cr>
nnoremap vs :vnew<cr>
nnoremap sp :new<cr>
"}}}
" setting fold{{{
set modeline
set foldmethod=marker
set commentstring=//%s//
"}}}
" setting neovim{{{
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
" set background=dark
set background=light
autocmd VimEnter,WinEnter,ColorScheme * highlight Visual term=underline ctermfg=195 ctermbg=30 guifg=#c6c8d1 guibg=#5b7881
autocmd VimEnter,WinEnter,ColorScheme * highlight BookMarkLine term=underline ctermfg=252 ctermbg=23 gui=undercurl guisp=#89b8c2
set t_Co=256
" colorscheme lucius
" colorscheme tender
colorscheme iceberg
" colorscheme breezy
" colorscheme dracula
" set termguicolors
syntax on
"}}}
let g:python_host_prog = substitute(system('which python'), "\n", "", "")
let g:python3_host_prog = substitute(system('which python3'), "\n", "", "")
" settings deoplete{{{
set completeopt=menuone
"}}}
" setting jedi{{{
" let g:jedi#completions_command = "<C-Space>"
" let g:jedi#rename_command = "[jedi]r"
" let g:jedi#popup_select_first = 0
" let g:jedi#popup_on_dot = 0
" let g:jedi#show_call_signatures = 1
" let g:jedi#show_call_signatures_delay = 10
"
" nnoremap <C-g> :call jedi#goto_assignments()<CR>
" nnoremap <C-k> :call jedi#show_documentation()<CR>
" nnoremap <C-u> :call jedi#usages()<CR>
" nnoremap <C-j> :call jedi#goto_definitions()<CR>
"}}}
nnoremap <C-k> :DeniteCursorWord -buffer-name=gtags_ref gtags_ref<cr>
" nnoremap <F6> :call Exec_gtags()<cr>
" function! Exec_gtags()
"     :ClearGTAGS
"     :GenGTAGS
" endfunction
" settings quickfix{{{
nnoremap <Space>p :cp<cr>
nnoremap <Space>n :cn<cr>
" tnoremap <silent> mm <c-\><c-n><c-w>p
" tnoremap <silent> tm <c-\><c-n>
"}}}
" settings dev env{{{
nnoremap <silent> <F9> :call Display_DevEnv_Toggle()<cr>
function! Display_DevEnv_Toggle()
    :Ttoggle
    :NERDTreeToggle
    :TagbarToggle
endfunction
"}}}
" setting range search{{{
vnoremap <silent> <Space>/ <ESC>/\%V
"}}}
autocmd BufNewFile *.py 0r $HOME/.config/nvim/template/python/aapf_dev.py
" settings terminal mode {{{
" change cursol shape in terminal mode
if has('vim_starting')
    " 挿入モード時に非点滅の縦棒タイプのカーソル
    let &t_SI .= "\e[6 q"
    " ノーマルモード時に非点滅のブロックタイプのカーソル
    let &t_EI .= "\e[2 q"
    " 置換モード時に非点滅の下線タイプのカーソル
    let &t_SR .= "\e[4 q"
endif"}}}
" settings gather tab{{{
if exists('*win_gotoid')
  function! s:buf_open_existing(qmods, bname) abort " {{{
    let bnr = bufnr(a:bname)
    if bnr == -1
      echoerr 'Buffer not found:' a:bname
      return
    endif
    let wids = win_findbuf(bnr)
    if empty(wids)
      execute a:qmods 'new'
      execute 'buffer' bnr
    else
      call win_gotoid(wids[0])
    endif
  endfunction " }}}
  command! -bar -nargs=1 -complete=buffer Buffer  call s:buf_open_existing(<q-mods>, <f-args>)
else
  function! s:buf_open_existing(bname) abort " {{{
    let bnr = bufnr(a:bname)
    if bnr == -1
      echoerr 'Buffer not found:' a:bname
      return
    endif
    let tindice = map(filter(map(range(1, tabpagenr('$')), '{"tindex": v:val, "blist": tabpagebuflist(v:val)}'), 'index(v:val.blist, bnr) != -1'), 'v:val.tindex')
    if empty(tindice)
      new
      execute 'buffer' bnr
    else
      execute 'tabnext' tindice[0]
      execute bufwinnr(bnr) 'wincmd w'
    endif
  endfunction " }}}
  command! -bar -nargs=1 -complete=buffer Buffer  call s:buf_open_existing(<f-args>)
endif"}}}
" settings md as markdown, instead of modula2
autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
set dictionary=/usr/share/dict/words
nnoremap ms :Recter<cr>
" set updatetime=250
nnoremap tbs :split enew<cr>
nnoremap tbv :vsplit enew<cr>

" settings convert ipynb to python{{{
" augroup ipynb
"     autocmd!
"     autocmd BufRead *.ipynb
" augroup END
" command! Nbconvert setlocal
" jupyter nbconvert --to python expand("%")
"}}}
" autocmd BufWritePost ~/.config/nvim/init.vim so ~/.config/nvim/init.vim
" autocmd BufWritePost ~/.config/nvim/dein.toml execute UpdateRemotePlugins
set clipboard=unnamed
nnoremap ss :%s/ *$//g<cr>
" xnoremap SWP :!rm -f ~/.local/share/nvim/swap/*
let &colorcolumn=join(range(90,999),",")                                                                                                                                                                                         
hi ColorColumn ctermbg=235 guibg=#2c2d27 
