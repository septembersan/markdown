" generic setting "{{{
" set spell
set spelllang=en,cjk
nnoremap ,l <C-w>L
nnoremap ,j <C-w>J
nnoremap ,k <C-w>K
nnoremap ,h <C-w>H
" setting open vimrc "{{{
command VI :tabnew ~/.config/nvim/init.vim
command DE :tabnew ~/.config/nvim/dein.toml
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
nnoremap tm :tabnext
nnoremap tn :tabnew<CR>
nnoremap to :tabonly<CR>
nnoremap tp :tab sp<CR>
nnoremap <Space>x :call My_tabclose()<CR>
nnoremap <Space>q :call My_tabclose()<CR>
nnoremap <Space>a gg<S-v><S-g>
nnoremap <c-c> :only<CR>
function! My_tabclose()
  :tabclose
  :tabprevious
endfunction
nnoremap <silent>vp gv
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
set t_Co=256
" colorscheme lucius
" colorscheme tender
colorscheme iceberg
" colorscheme breezy
" colorscheme dracula
" set termguicolors
syntax on
"}}}
let g:python_host_prog = substitute(system('which python3.6'), "\n", "", "")
let g:python3_host_prog = substitute(system('which python3.6'), "\n", "", "")
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
tnoremap <silent> mm <c-\><c-n>
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
" setting python_fn{{{
" -*- vim -*-
" FILE: python_fn.vim
" LAST MODIFICATION: 2008-08-28 8:19pm
" (C) Copyright 2001-2005 Mikael Berthe <bmikael@lists.lilotux.net>
" Maintained by Jon Franklin <jvfranklin@gmail.com>
" Version: 1.13

" USAGE:
"
" Save this file to $VIMFILES/ftplugin/python.vim. You can have multiple
" python ftplugins by creating $VIMFILES/ftplugin/python and saving your
" ftplugins in that directory. If saving this to the global ftplugin 
" directory, this is the recommended method, since vim ships with an
" ftplugin/python.vim file already.
" You can set the global variable "g:py_select_leading_comments" to 0
" if you don't want to select comments preceding a declaration (these
" are usually the description of the function/class).
" You can set the global variable "g:py_select_trailing_comments" to 0
" if you don't want to select comments at the end of a function/class.
" If these variables are not defined, both leading and trailing comments
" are selected.
" Example: (in your .vimrc) "let g:py_select_leading_comments = 0"
" You may want to take a look at the 'shiftwidth' option for the
" shift commands...
"
" REQUIREMENTS:
" vim (>= 7)
"
" Shortcuts:
"   ]t      -- Jump to beginning of block
"   ]e      -- Jump to end of block
"   ]v      -- Select (Visual Line Mode) block
"   ]<      -- Shift block to left
"   ]>      -- Shift block to right
"   ]#      -- Comment selection
"   ]u      -- Uncomment selection
"   ]c      -- Select current/previous class
"   ]d      -- Select current/previous function
"   ]<up>   -- Jump to previous line with the same/lower indentation
"   ]<down> -- Jump to next line with the same/lower indentation

" Only do this when not done yet for this buffer
if exists("b:loaded_py_ftplugin")
  finish
endif
let b:loaded_py_ftplugin = 1

" if expand("%:t") =~ ".*\.py"
  " map  ]t   :PBoB<CR>
  " vmap ]t   :<C-U>PBOB<CR>m'gv``
  " map  ]e   :PEoB<CR>
  " vmap ]e   :<C-U>PEoB<CR>m'gv``
  "
  " map  ]v   ]tV]e
  " map  ]<   ]tV]e<
  " vmap ]<   <
  " map  ]>   ]tV]e>
  " vmap ]>   >
  "
  " map  ]#   :call PythonCommentSelection()<CR>
  " vmap ]#   :call PythonCommentSelection()<CR>
  " map  ]u   :call PythonUncommentSelection()<CR>
  " vmap ]u   :call PythonUncommentSelection()<CR>
  "
  nnoremap <silent>  vc   :call PythonSelectObject("class")<CR>
  nnoremap <silent>  vd   :call PythonSelectObject("function")<CR>
  "
  " map  ]<up>    :call PythonNextLine(-1)<CR>
  " map  ]<down>  :call PythonNextLine(1)<CR>
  " " You may prefer use <s-up> and <s-down>... :-)
  "
  " " jump to previous class
  nnoremap <silent> [c   :call PythonDec("class", -1)<CR>
  vnoremap <silent> [c   :call PythonDec("class", -1)<CR>
  "     
  " " jump to next class
  nnoremap <silent> ]c   :call PythonDec("class", 1)<CR>
  vnoremap <silent> ]c   :call PythonDec("class", 1)<CR>
  "
  " " jump to previous function
  nnoremap <silent> [d   :call PythonDec("function", -1)<CR>
  vnoremap <silent> [d   :call PythonDec("function", -1)<CR>
  "
  " " jump to next function
  nnoremap <silent> ]d   :call PythonDec("function", 1)<CR>
  vnoremap <silent> ]d   :call PythonDec("function", 1)<CR>
" endif


" Menu entries
nmenu <silent> &Python.Update\ IM-Python\ Menu 
    \:call UpdateMenu()<CR>
nmenu &Python.-Sep1- :
nmenu <silent> &Python.Beginning\ of\ Block<Tab>[t 
    \]t
nmenu <silent> &Python.End\ of\ Block<Tab>]e 
    \]e
nmenu &Python.-Sep2- :
nmenu <silent> &Python.Shift\ Block\ Left<Tab>]< 
    \]<
vmenu <silent> &Python.Shift\ Block\ Left<Tab>]< 
    \]<
nmenu <silent> &Python.Shift\ Block\ Right<Tab>]> 
    \]>
vmenu <silent> &Python.Shift\ Block\ Right<Tab>]> 
    \]>
nmenu &Python.-Sep3- :
vmenu <silent> &Python.Comment\ Selection<Tab>]# 
    \]#
nmenu <silent> &Python.Comment\ Selection<Tab>]# 
    \]#
vmenu <silent> &Python.Uncomment\ Selection<Tab>]u 
    \]u
nmenu <silent> &Python.Uncomment\ Selection<Tab>]u 
    \]u
nmenu &Python.-Sep4- :
nmenu <silent> &Python.Previous\ Class<Tab>]J 
    \]J
nmenu <silent> &Python.Next\ Class<Tab>]j 
    \]j
nmenu <silent> &Python.Previous\ Function<Tab>]F 
    \]F
nmenu <silent> &Python.Next\ Function<Tab>]f 
    \]f
nmenu &Python.-Sep5- :
nmenu <silent> &Python.Select\ Block<Tab>]v 
    \]v
nmenu <silent> &Python.Select\ Function<Tab>]d 
    \]d
nmenu <silent> &Python.Select\ Class<Tab>]c 
    \]c
nmenu &Python.-Sep6- :
nmenu <silent> &Python.Previous\ Line\ wrt\ indent<Tab>]<up> 
    \]<up>
nmenu <silent> &Python.Next\ Line\ wrt\ indent<Tab>]<down> 
    \]<down>

:com! PBoB execute "normal ".PythonBoB(line('.'), -1, 1)."G"
:com! PEoB execute "normal ".PythonBoB(line('.'), 1, 1)."G"
:com! UpdateMenu call UpdateMenu()


" Go to a block boundary (-1: previous, 1: next)
" If force_sel_comments is true, 'g:py_select_trailing_comments' is ignored
function! PythonBoB(line, direction, force_sel_comments)
  let ln = a:line
  let ind = indent(ln)
  let mark = ln
  let indent_valid = strlen(getline(ln))
  let ln = ln + a:direction
  if (a:direction == 1) && (!a:force_sel_comments) && 
      \ exists("g:py_select_trailing_comments") && 
      \ (!g:py_select_trailing_comments)
    let sel_comments = 0
  else
    let sel_comments = 1
  endif

  while((ln >= 1) && (ln <= line('$')))
    if  (sel_comments) || (match(getline(ln), "^\\s*#") == -1)
      if (!indent_valid)
        let indent_valid = strlen(getline(ln))
        let ind = indent(ln)
        let mark = ln
      else
        if (strlen(getline(ln)))
          if (indent(ln) < ind)
            break
          endif
          let mark = ln
        endif
      endif
    endif
    let ln = ln + a:direction
  endwhile

  return mark
endfunction


" Go to previous (-1) or next (1) class/function definition
function! PythonDec(obj, direction)
  if (a:obj == "class")
    let objregexp = "^\\s*class\\s\\+[a-zA-Z0-9_]\\+"
        \ . "\\s*\\((\\([a-zA-Z0-9_,. \\t\\n]\\)*)\\)\\=\\s*:"
  else
    let objregexp = "^\\s*def\\s\\+[a-zA-Z0-9_]\\+\\s*(\\_[^:#]*)\\s*:"
  endif
  let flag = "W"
  if (a:direction == -1)
    let flag = flag."b"
  endif
  let res = search(objregexp, flag)
endfunction


" Comment out selected lines
" commentString is inserted in non-empty lines, and should be aligned with
" the block
function! PythonCommentSelection()  range
  let commentString = "#"
  let cl = a:firstline
  let ind = 1000    " I hope nobody use so long lines! :)

  " Look for smallest indent
  while (cl <= a:lastline)
    if strlen(getline(cl))
      let cind = indent(cl)
      let ind = ((ind < cind) ? ind : cind)
    endif
    let cl = cl + 1
  endwhile
  if (ind == 1000)
    let ind = 1
  else
    let ind = ind + 1
  endif

  let cl = a:firstline
  execute ":".cl
  " Insert commentString in each non-empty line, in column ind
  while (cl <= a:lastline)
    if strlen(getline(cl))
      execute "normal ".ind."|i".commentString
    endif
    execute "normal \<Down>"
    let cl = cl + 1
  endwhile
endfunction

" Uncomment selected lines
function! PythonUncommentSelection()  range
  " commentString could be different than the one from CommentSelection()
  " For example, this could be "# \\="
  let commentString = "#"
  let cl = a:firstline
  while (cl <= a:lastline)
    let ul = substitute(getline(cl),
             \"\\(\\s*\\)".commentString."\\(.*\\)$", "\\1\\2", "")
    call setline(cl, ul)
    let cl = cl + 1
  endwhile
endfunction


" Select an object ("class"/"function")
function! PythonSelectObject(obj)
  " Go to the object declaration
  normal $
  call PythonDec(a:obj, -1)
  let beg = line('.')

  if !exists("g:py_select_leading_comments") || (g:py_select_leading_comments)
    let decind = indent(beg)
    let cl = beg
    while (cl>1)
      let cl = cl - 1
      if (indent(cl) == decind) && (getline(cl)[decind] == "#")
        let beg = cl
      else
        break
      endif
    endwhile
  endif

  if (a:obj == "class")
    let eod = "\\(^\\s*class\\s\\+[a-zA-Z0-9_]\\+\\s*"
            \ . "\\((\\([a-zA-Z0-9_,. \\t\\n]\\)*)\\)\\=\\s*\\)\\@<=:"
  else
   let eod = "\\(^\\s*def\\s\\+[a-zA-Z0-9_]\\+\\s*(\\_[^:#]*)\\s*\\)\\@<=:"
  endif
  " Look for the end of the declaration (not always the same line!)
  call search(eod, "")

  " Is it a one-line definition?
  if match(getline('.'), "^\\s*\\(#.*\\)\\=$", col('.')) == -1
    let cl = line('.')
    execute ":".beg
    execute "normal V".cl."G"
  else
    " Select the whole block
    execute "normal \<Down>"
    let cl = line('.')
    execute ":".beg
    execute "normal V".PythonBoB(cl, 1, 0)."G"
  endif
endfunction


" Jump to the next line with the same (or lower) indentation
" Useful for moving between "if" and "else", for example.
function! PythonNextLine(direction)
  let ln = line('.')
  let ind = indent(ln)
  let indent_valid = strlen(getline(ln))
  let ln = ln + a:direction

  while((ln >= 1) && (ln <= line('$')))
    if (!indent_valid) && strlen(getline(ln)) 
        break
    else
      if (strlen(getline(ln)))
        if (indent(ln) <= ind)
          break
        endif
      endif
    endif
    let ln = ln + a:direction
  endwhile

  execute "normal ".ln."G"
endfunction

function! UpdateMenu()
  " delete menu if it already exists, then rebuild it.
  " this is necessary in case you've got multiple buffers open
  " a future enhancement to this would be to make the menu aware of
  " all buffers currently open, and group classes and functions by buffer
  if exists("g:menuran")
    aunmenu IM-Python
  endif
  let restore_fe = &foldenable
  set nofoldenable
  " preserve disposition of window and cursor
  let cline=line('.')
  let ccol=col('.') - 1
  norm H
  let hline=line('.')
  " create the menu
  call MenuBuilder()
  " restore disposition of window and cursor
  exe "norm ".hline."Gzt"
  let dnscroll=cline-hline
  exe "norm ".dnscroll."j".ccol."l"
  let &foldenable = restore_fe
endfunction

function! MenuBuilder()
  norm gg0
  let currentclass = -1
  let classlist = []
  let parentclass = ""
  while line(".") < line("$")
    " search for a class or function
    if match ( getline("."), '^\s*class\s\+[_a-zA-Z].*\|^\s*def\s\+[_a-zA-Z].*' ) != -1
      norm ^
      let linenum = line('.')
      let indentcol = col('.')
      norm "nye
      let classordef=@n
      norm w"nywge
      let objname=@n
      let parentclass = FindParentClass(classlist, indentcol)
      if classordef == "class"
        call AddClass(objname, linenum, parentclass)
      else " this is a function
        call AddFunction(objname, linenum, parentclass)
      endif
      " We actually created a menu, so lets set the global variable
      let g:menuran=1
      call RebuildClassList(classlist, [objname, indentcol], classordef)
    endif " line matched
    norm j
  endwhile
endfunction

" classlist contains the list of nested classes we are in.
" in most cases it will be empty or contain a single class
" but where a class is nested within another, it will contain 2 or more
" this function adds or removes classes from the list based on indentation
function! RebuildClassList(classlist, newclass, classordef)
  let i = len(a:classlist) - 1
  while i > -1
    if a:newclass[1] <= a:classlist[i][1]
      call remove(a:classlist, i)
    endif
    let i = i - 1
  endwhile
  if a:classordef == "class"
    call add(a:classlist, a:newclass)
  endif
endfunction

" we found a class or function, determine its parent class based on
" indentation and what's contained in classlist
function! FindParentClass(classlist, indentcol)
  let i = 0
  let parentclass = ""
  while i < len(a:classlist)
    if a:indentcol <= a:classlist[i][1]
      break
    else
      if len(parentclass) == 0
        let parentclass = a:classlist[i][0]
      else
        let parentclass = parentclass.'\.'.a:classlist[i][0]
      endif
    endif
    let i = i + 1
  endwhile
  return parentclass
endfunction

" add a class to the menu
function! AddClass(classname, lineno, parentclass)
  if len(a:parentclass) > 0
    let classstring = a:parentclass.'\.'.a:classname
  else
    let classstring = a:classname
  endif
  exe 'menu IM-Python.classes.'.classstring.' :call <SID>JumpToAndUnfold('.a:lineno.')<CR>'
endfunction

" add a function to the menu, grouped by member class
function! AddFunction(functionname, lineno, parentclass)
  if len(a:parentclass) > 0
    let funcstring = a:parentclass.'.'.a:functionname
  else
    let funcstring = a:functionname
  endif
  exe 'menu IM-Python.functions.'.funcstring.' :call <SID>JumpToAndUnfold('.a:lineno.')<CR>'
endfunction


function! s:JumpToAndUnfold(line)
  " Go to the right line
  execute 'normal '.a:line.'gg'
  " Check to see if we are in a fold
  let lvl = foldlevel(a:line)
  if lvl != 0
    " and if so, then expand the fold out, other wise, ignore this part.
    execute 'normal 15zo'
  endif
endfunction

"" This one will work only on vim 6.2 because of the try/catch expressions.
" function! s:JumpToAndUnfoldWithExceptions(line)
"  try 
"    execute 'normal '.a:line.'gg15zo'
"  catch /^Vim\((\a\+)\)\=:E490:/
"    " Do nothing, just consume the error
"  endtry
"endfunction


" vim:set et sts=2 sw=2:
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
nnoremap <F12> :Recter<cr>
