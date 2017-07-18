" rsi.vim - Readline style insertion
" Maintainer:   Tim Pope
" Version:      1.0
" GetLatestVimScripts: 4359 1 :AutoInstall: rsi.vim

if exists("g:loaded_rsi") || v:version < 700 || &cp
  finish
endif
let g:loaded_rsi = 1

set ttimeout
if &ttimeoutlen == -1
  set ttimeoutlen=50
endif

inoremap        <C-A> <C-O>^
inoremap   <C-X><C-A> <C-A>
cnoremap        <C-A> <Home>
cnoremap   <C-X><C-A> <C-A>

inoremap <expr> <C-B> getline('.')=~'^\s*$'&&col('.')>strlen(getline('.'))?"0\<Lt>C-D>\<Lt>Esc>kJs":"\<Lt>Left>"
cnoremap        <C-B> <Left>

inoremap <expr> <C-C> pumvisible()?"\<Lt>C-E>":"\<Lt>C-C>"

inoremap <expr> <C-D> col('.')>strlen(getline('.'))?"\<Lt>C-D>":"\<Lt>Del>"
cnoremap <expr> <C-D> getcmdpos()>strlen(getcmdline())?"\<Lt>C-D>":"\<Lt>Del>"
cnoremap   <C-X><C-D> <C-D>

inoremap <expr> <C-E> col('.')>strlen(getline('.'))?"\<Lt>C-E>":"\<Lt>End>"

inoremap <expr> <C-F> col('.')>strlen(getline('.'))?"\<Lt>C-F>":"\<Lt>Right>"
cnoremap <expr> <C-F> getcmdpos()>strlen(getcmdline())?&cedit:"\<Lt>Right>"
cnoremap   <C-X><C-F> <C-F>

cnoremap   <C-X><C-K> <C-\>e<SID>CmdlineKillLine()<CR>
function! s:CmdlineKillLine() abort
  let pos = getcmdpos()
  if pos == 1
    " Vim's string indexing is messed up so I think we need a special case
    " here. getcmdline()[0 : -1] would select the whole string.
    return ""
  else
    " Subtract two because right index is inclusive and because getcmdpos()
    " starts at 1.
    return getcmdline()[0 : pos-2]
  endif
endfunction

inoremap <expr> <C-L> &insertmode<bar><bar>pumvisible()?"\<Lt>C-L>":"\<Lt>C-\>\<Lt>C-O>".<SID>EmacsCtrlL()
function! s:EmacsCtrlL()
  if abs(winline()) <= 1+&scrolloff
    return 'zb'
  elseif abs(winline() - (1+winheight(0))/2) <= 1
    return 'zt'
  else
    return 'zz'
  endif
endfunction

if exists('g:rsi_no_meta')
  finish
endif

if &encoding ==# 'latin1' && has('gui_running') && !empty(findfile('plugin/sensible.vim', escape(&rtp, ' ')))
  set encoding=utf-8
endif

noremap!        <M-b> <S-Left>
noremap!        <M-d> <C-O>dw
cnoremap        <M-d> <S-Right><C-W>
noremap!        <M-BS> <C-W>
noremap!        <M-f> <S-Right>
noremap!        <M-n> <Down>
noremap!        <M-p> <Up>
inoremap        <M-q> <C-\><C-O>gwip
nnoremap        <M-q> gwip
vnoremap        <M-q> gw
nnoremap        <M-l> guew
inoremap        <M-l> <C-O>gue<C-O>w
nnoremap        <M-u> gUew
inoremap        <M-u> <C-O>gUe<C-O>w
nnoremap        <M-c> gUlw
inoremap        <M-c> <C-O>gUl<C-O>w

if !has("gui_running") && !has('nvim')
  silent! exe "set <S-Left>=\<Esc>b"
  silent! exe "set <S-Right>=\<Esc>f"
  silent! exe "set <F31>=\<Esc>d"
  silent! exe "set <F32>=\<Esc>n"
  silent! exe "set <F33>=\<Esc>p"
  silent! exe "set <F34>=\<Esc>\<C-?>"
  silent! exe "set <F35>=\<Esc>\<C-H>"
  silent! exe "set <F36>=\<Esc>q"
  silent! exe "set <F37>=\<Esc>l"
  " After F37 Vim stops mapping function keys. `man 5 terminfo` lists function
  " keys going all the way up to F63, so it's unclear to me why Vim doesn't go
  " as far. Going down to the 20s seems to work. *shurgs*
  silent! exe "set <F21>=\<Esc>u"
  silent! exe "set <F22>=\<Esc>c"
  map! <F31> <M-d>
  map! <F32> <M-n>
  map! <F33> <M-p>
  map! <F34> <M-BS>
  map! <F35> <M-BS>
  map! <F36> <M-q>
  map! <F37> <M-l>
  map! <F21> <M-u>
  map! <F22> <M-c>
  map <F31> <M-d>
  map <F32> <M-n>
  map <F33> <M-p>
  map <F34> <M-BS>
  map <F35> <M-BS>
  map <F36> <M-q>
  map <F37> <M-l>
  map <F21> <M-u>
  map <F22> <M-c>
endif

" vim:set et sw=2:
