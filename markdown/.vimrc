" generic setting "{{{ 
nnoremap j gj
nnoremap k gk

nnoremap * *N
"set t_ut=
if has('unix')
	let &t_ti.="\e[1 q"
	let &t_SI.="\e[5 q"
	let &t_EI.="\e[1 q"
	let &t_te.="\e[0 q"
endif
"set shiftwidth=4
"set softtabstop=4
"set expandtab
inoremap mm <ESC>
nnoremap mm <ESC>
vnoremap mm <ESC>
cnoremap mm <ESC>
set guioptions-=T
set guioptions-=m
set wildmenu
set wildmode=longest:full
syntax enable
set background=dark
set t_Co=256
set nobackup
set autoindent
set nu
set hlsearch

set virtualedit=all
set switchbuf=useopen
set matchpairs& matchpairs+=<:>

nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

nnoremap <Left> <C-w><<CR>
nnoremap <Right> <C-w>><CR>
nnoremap <S-Up> <C-w>-
nnoremap <S-Down> <C-w>+

cnoremap <C-b> <left>
cnoremap <C-f> <right>
if has('win64')
	set guifont=Myrica\ M:h12
endif
set iminsert=0

set laststatus=2

set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
nnoremap <silent><C-l> :set list<CR>
nnoremap <S-y> y$

" move easy window
nnoremap <Space>w <C-w>

vnoremap * "zy:let @/ = @z<CR>n
"}}}
" setting fold"{{{
set modeline
set foldmethod=marker
"}}}
" setting over write by following{{{
nnoremap <silent> cy ce <C-r>0<ESC>:let@/=@1<CR>:noh<CR>
vnoremap <silent> cy  c <C-r>0<ESC>:let@/=@1<CR>:noh<CR>
vnoremap <silent> ciy  ciw <C-r>0<ESC>:let@/=@1<CR>:noh<CR>
"}}}
"NeoBundle"{{{
"************************************************************
set nocompatible
filetype off            " for NeoBundle
 
if has('vim_starting')
        set rtp+=$HOME/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand('~/.vim/bundle'))
NeoBundleFetch 'Shougo/neobundle.vim'


" NeoBundle
"NeoBundle 'Shougo/neocomplcache.git'
NeoBundle 'Shougo/unite.vim.git'
NeoBundle 'Shougo/vimfiler.vim'
NeoBundle 'Shougo/vimproc.vim', {
\'build' : {
    \'linux' : 'make',
    \},
\}
NeoBundle 'Shougo/vimshell.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/neoyank.vim'
NeoBundle 'vim-scripts/DirDiff.vim'
NeoBundle 'Align'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'vim-scripts/zoom.vim'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'vim-scripts/taglist.vim'
"NeoBundle 'itchyny/lightline.vim'
NeoBundle 'thinca/vim-quickrun'
NeoBundle '5t111111/alt-gtags.vim'
NeoBundle 'fuenor/qfixgrep'
NeoBundle 'fuenor/qfixhowm'
NeoBundle 'junegunn/vim-easy-align'
NeoBundle 'pebble8888/doxygen_comment_creator'
NeoBundle 'vim-scripts/gtags.vim'
NeoBundle 'tomasr/molokai'
NeoBundle 'vim-scripts/DoxygenToolkit.vim'
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'kana/vim-operator-user'
NeoBundle 'kana/vim-operator-replace'
NeoBundle 'rhysd/vim-operator-surround'
NeoBundle 'emonkak/vim-operator-comment'
NeoBundle 'emonkak/vim-operator-sort'
NeoBundle 'davidhalter/jedi-vim'
NeoBundle 'sjl/gundo.vim'
NeoBundle 'rhysd/unite-n3337'
NeoBundle 'lyuts/vim-rtags'
NeoBundle 't9md/vim-quickhl'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'dhruvasagar/vim-table-mode'
NeoBundle 'vim-airline/vim-airline'

NeoBundle 'Shougo/neocomplete.vim'

call neobundle#end()

"call smartinput#map_to_trigger('i' '<Plug>(smartinput_BS)',
"            \                   '<BS>'
"            \                   '<BS>')
 
filetype plugin indent on       " restore filetype
"************************************************************
"}}}
"setting unite{{{
let g:unite_enable_start_insert=1

nnoremap <silent> <Space>b :<C-u>Unite buffer<CR>
nnoremap <silent> <Space>f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> <Space>r :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> <Space>m :<C-u>Unite file_mru<CR>
nnoremap <silent> <Space>u :<C-u>Unite buffer file_mru<CR>
nnoremap <silent> <Space>y :<C-u>Unite history/yank<CR>
nnoremap <silent> <Space>d :<C-u>Unite bookmark<CR>
"nnoremap <silent> <Space>d :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
"au FileType unite nnoremap <silent> <buffer> <expr> <C-h> unite#do_action('split')
"au FileType unite inoremap <silent> <buffer> <expr> <C-h> unite#do_action('split')
au FileType unite nnoremap <silent> <buffer> <expr> <C-v> unite#do_action('vsplit')
"au FileType unite inoremap <silent> <buffer> <expr> <C-v> unite#do_action('vsplit')
au FileType unite nnoremap <silent> <buffer> <expr> <Space>t unite#do_action('tabopen')
"au FileType unite inoremap <silent> <buffer> <expr> <Space>t unite#do_action('tabopen')
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> q
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>q

inoremap <buffer> <mm> <Plug> (uite_insert_leave)
"}}}
" setting tagbar"{{{
" [Usage]
" tag jump: p
let g:tagbar_width = 30
let g:tagbar_autoshowtag = 0
let g:tagbar_expand = 1
noremap <silent> <F8> :TagbarToggle<CR>
set statusline=%F%m%r%h%w\%=%{tagbar#currenttag('[%s]','')}\[Pos=%v,%l]\[Len=%L]
"}}}
" setting Doxygen"{{{
noremap ,d :Dox<CR>

nnoremap <Space>l gt
nnoremap <Space>h gT
"}}}
" setting vimfiler"{{{
"************************************************************
nnoremap <silent><F7> :VimFilerExplorer<CR>
"}}}
" neocomplete"{{{
"************************************************************
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
inoremap <C-m> <ESC>
"}}}
" setting gtags"{{{
if expand("%:t") =~ ".*\.cpp"
	map <C-q> <C-w><C-w><C-w>q
	map <C-g> :Gtags -g
	map <C-l> :Gtags -f %<CR>
	map <C-j> :GtagsCursor<CR>
	map <C-k> :Gtags -r <C-r><C-w><CR>
	map <C-h> :GtagsCursor<CR>
	map <C-n> :cn<CR>
	map <C-p> :cp<CR>
endif
"}}}
"  setting howm{{{
let QFixHown_Key = 'g'
if has('win64')
	let howm_dir = 'c:/howm'
	let howm_fileencoding = 'cp932'
	let howm_fileformat = 'dos'
else
	let howm_dir = '/home/okada-hxf'
	let howm_fileencoding = 'utf-8'
	let howm_fileencoding = 'unix'
endif
let howm_filename = '%Y/%m/%Y^%m-%d-%H%M%S.txt'
let g:QFixHowm_WildCardChapter = 1
let QFixHowm_FoldingChapterTitle = 1
let QFixHowm_Folding = 0
"}}}
" windows"{{{
nnoremap <space>a gg<S-v><S-g>
vnoremap <space>c "*y
nnoremap <space>v "*p
"}}}
" setting vim-easymotion"{{{
" let g:EasyMotion_do_mapping = 0
" nmap s <Plug>(easymotion-s2)
" xmap s <Plug>(easymotion-s2)
" omap z <Plug>(easymotion-s2)
" nmap g/ <Plug>(easymotion-sn)
" xmap g/ <Plug>(easymotion-sn)
" omap g/ <Plug>(easymotion-tn)
" let g:EasyMotion_smartcase = 1
" map <Leader>j <Plug>(easymotion-j)
" map <Leader>k <Plug>(easymotion-k)
" let g:EasyMotion_startofline = 0
" let g:EasyMotion_keys = 'QZASDFGHJKL;'
" let g:EasyMotion_use_upper = 1
" let g:EasyMotion_enter_jump_first = 1
" let g:EasyMotion_space_jump_first = 1
" hi EasyMotionTarget guifg=#80a0ff ctermfg=81
"}}}
" setting one line is 80 charactor"{{{
highlight trun gui=standout cterm=standout
call matchadd("trun", '.\%>81v')

noremap <Plug> (ToggleColorColumn)
            \ :<c-U>let &colorcolumn = len(&colorcolumn) > 0 ? '' :
            \   join(range(81, 9999), ',')<CR>

nnoremap cc <Plug> (ToggleColorColumn)
"}}}
" setting neosnippet"{{{
inoremap <C-k> <Plug>(neosnippet_expand_or_jump)
snoremap <C-k> <Plug>(neosnippet_expand_or_jump)
xnoremap <C-k> <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
"inoremap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \     "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
snoremap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)>" : "\<TAB>"

" For conceal markers
if has('conceal')
    set conceallevel=2 concealcursor=niv
endif

"set snippets file dir
let g:neosnippet#snippets_directory='~/.vim/bundle/neosnippet-snippets/snippets/,~/.vim/snippets'
"}}}
" setting operator-replace"{{{
nnoremap _ <Plug>(operator-replace)
"}}}
" setting operator-surround"{{{
" nnoremap sa <Plug>(operator-surround-append-input-in-advance)
" nnoremap s( <Plug>(operator-surround-append-input-in-advance)(
" nnoremap sb <Plug>(operator-surround-append-input-in-advance)(
" nnoremap s{ <Plug>(operator-surround-append-input-in-advance){
" nnoremap s[ <Plug>(operator-surround-append-input-in-advance)[
" nnoremap s" <Plug>(operator-surround-append-input-in-advance)"
" nnoremap s' <Plug>(operator-surround-append-input-in-advance)'
map <silent>sa <Plug>(operator-surround-append)
map <silent>sd <Plug>(operator-surround-delete)
map <silent>sr <Plug>(operator-surround-replace)

nmap <silent>sdd <Plug>(operator-surround-delete)<Plug>(textobj-multiblock-a)
nmap <silent>srr <Plug>(operator-surround-replace)<Plug>(textobj-multiblock-a)

"map <silent>sdd <Plug>(operator-surround-delete)<Plug>(textobj-anyblock-a)
"map <silent>srr <Plug>(operator-surround-replace)<Plug>(textobj-anyblock-a)

"map <silent>sdb <Plug>(operator-surround-delete)<Plug>(textobj-between-a)
"map <silent>srb <Plug>(operator-surround-replace)<Plug>(textobj-between-a)
"}}}
" setting jedi-vi"{{{
" autocmd FileType python setlocal omnifunc=jedi#completions
" let g:jedi#completions_enabled = 0
" let g:jedi#auto_vim_configuration = 0
" if !exists('g:neocomplete#force_omni_input_patterns')
"     let g:neocomplete#force_omni_input_patterns = {}
" endif
" 
" autocmd FileType python setlocal completeopt-=preview
"}}}
"g:neocomplete#force_omni_input_patterns.python = '\h\w*\|[^. \t]\.\w*'
" setting neoyank.vim"{{{
"g:neoyank#limit
"g:neoyank#file
"g:neoyank#registers
"}}}
" setting vimshell"{{{
"nnoremap <silent><Space>s :VimShell<CR>
"nnoremap <F5> :VimShellSendString<CR>
"}}}
" setting gundo"{{{
nnoremap <silent>U :<C-u>GundoToggle<CR>
if has('win64')
	set undodir=D:/Tool/vim74-kaoriya-win64/undo
else
	set undodir=/root/.vimundo
endif
set undofile
"}}}
" setting easy align"{{{
" how to easy align
" -> <CR> in vmode
"    ->  *|     *(col number)
" two <CR>   is right-aligned
" three <CR> is center-aligned
vnoremap <Enter> <Plug>(EasyAlign)
nnoremap ga <Plug>(EasyAlign)
"}}}
" setting Align"{{{
vnoremap <Space>a :Align 
"}}}
" setting run cpp"{{{
function! MyExecuteCpp()
	:call system("clear")
	:!rcpp %
endfunction

if expand("%:t") =~ ".*\.cpp"
	nnoremap <F5> :call MyExecuteCpp()<CR>
endif
"}}}
" setting run python"{{{
function! MyExecutePython()
python << PYTHON
PYTHON
	:!python3 %
	:!clear
endfunction

if expand("%:t") =~ ".*\.py"
	nnoremap <F5> :call MyExecutePython()<CR>
endif
"}}}
" setting rtags"{{{
" jump define
"nnoremap <silent> <F3> :call rtags#JumpTo()<CR>
" jump refer
"nnoremap <silent> <F4> :<C-u>Unite<Space>rtags/references<CR>
" jump class or method head
"nnoremap <silent> <F5> :call rtags#JumpToParent()<CR>"}}}
" setting quickhl(multi search high light)"{{{
nmap <Space>s <Plug>(quickhl-manual-this)
nmap <Space>se <Plug>(quickhl-manual-reset)
"}}}
" setting jedi-vim"{{{
NeoBundleLazy "davidhalter/jedi-vim", {
    \ "autoload": { "filetypes": [ "python", "python3", "djangohtml"] }}

if ! empty(neobundle#get("jedi-vim"))
    let g:jedi#auto_initialization = 1
    let g:jedi#auto_vim_configuration = 1

nnoremap [jedi] <Nop>
xnoremap [jedi] <Nop>
nnoremap <Leader>j [jedi]
xnoremap <Leader>j [jedi]

"# 補完キーの設定この場合はCtrl+Space
let g:jedi#completions_command = "<C-Space>"    
"# 変数の宣言場所へジャンプ（Ctrl + g)
let g:jedi#goto_assignments_command = "<C-g>"   
"# クラス、関数定義にジャンプ（Gtrl + d）
let g:jedi#goto_definitions_command = "<C-j>"   
"# Pydocを表示（Ctrl + k）
let g:jedi#documentation_command = "<C-k>"      
let g:jedi#rename_command = "[jedi]r"
let g:jedi#usages_command = "<C-h>"
let g:jedi#popup_select_first = 0
let g:jedi#popup_on_dot = 0

autocmd FileType python setlocal completeopt-=preview

" for w/ neocomplete
    if ! empty(neobundle#get("neocomplete.vim"))
    autocmd FileType python setlocal omnifunc=jedi#completions
    let g:jedi#completions_enabled = 0
    let g:jedi#auto_vim_configuration = 0
"    let g:neocomplete#force_omni_input_patterns.python =
"            \ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
    let g:neocomplete#force_omni_input_patterns = {}
    endif
endif
"}}}
" setting vim-table-mode"{{{
" [Usage ]
" ------------------------------
" toggle table mode # <S-t>
" create edge       # |
" create line       # ||
" align right       
"  1. :
"  2. <>
"  create table after write param 
"  1. follwing -> param1, param2
"  2. :Tableize (in virtual mode)
"
nnoremap <silent><S-t> :TableModeToggle<CR>
vnoremap <silent><S-t> :Tableize<CR>
let g:table_mode_corner_corner="+"
let g:table_mode_header_fillchar="="

function! s:isAtStartOfLine(mapping)
	let text_before_cursor = getline('.')[0 : col('.')-1]
	let mapping_pattern = '\V' . escape(a:mapping, '\')
	let co |ttern = '\V' . escape(substitute(&l:cong, '%s.*$', '', ''), '\')
        return (text_before_cursor =~? '^' . ('\v(' . co |ttern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
endfunction

inoreabbrev <expr> <bar><bar>
		\ <SID>isAtStartOfLine('\|\|') ?
		\ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
inoreabbrev <expr> __
		\ <SID>isAtStartOfLine('__') ?
		\ '<c-o>:silent! TableModeDisable<cr>' : '__'
"}}}
colorscheme molokai
