"=============================================================================
" FILE: ipython.vim
" AUTHOR:  Sohei Suzuki <suzuki.s1008 at gmail.com>
" License: MIT license
"=============================================================================
scriptencoding utf-8

if !has('nvim')
    echomsg 'Ipython.vim requires Neovim.'
    finish
endif

" if !exists('*splitterm#open')
"     echoerr 'You have to install "szkny/SplitTerm" (neovim plugin) !'
"     finish
" endif

command! IpythonLine call ipython#run('line')
command! IpythonInspection call ipython#run('inspection')
command! IpythonRun call ipython#run('file')
command! IpythonClear call ipython#run('clear')
command! -range VIpython call ipython#run_visual()
command! IpythonDebug call ipython#run('debug')
