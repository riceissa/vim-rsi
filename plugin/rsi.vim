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

function! s:ctrl_u()
  if getcmdpos() > 1
    let @- = getcmdline()[:getcmdpos()-2]
  endif
  return "\<C-U>"
endfunction

cnoremap <expr> <C-U> <SID>ctrl_u()
cnoremap <expr> <C-Y> pumvisible() ? "\<C-Y>" : "\<C-R>-"

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

function! s:MapMeta() abort
  noremap!        <M-b> <S-Left>
  noremap!        <M-f> <S-Right>
  noremap!        <M-d> <C-O>dw
  cnoremap        <M-d> <S-Right><C-W>
  noremap!        <M-n> <Down>
  noremap!        <M-p> <Up>
  noremap!        <M-BS> <C-W>
  noremap!        <M-C-h> <C-W>
  inoremap        <M-q> <C-\><C-O>gwip
  nnoremap        <M-q> gwip
  vnoremap        <M-q> gw
  nnoremap        <M-l> guew
  inoremap        <M-l> <C-O>gue<C-O>w
  nnoremap        <M-u> gUew
  inoremap        <M-u> <C-O>gUe<C-O>w
  nnoremap        <M-c> gUlw
  inoremap        <M-c> <C-O>gUl<C-O>w
endfunction

if has("gui_running") || has('nvim')
  call s:MapMeta()
else
  silent! exe "set <F29>=\<Esc>b"
  silent! exe "set <F30>=\<Esc>f"
  silent! exe "set <F31>=\<Esc>d"
  silent! exe "set <F32>=\<Esc>n"
  silent! exe "set <F33>=\<Esc>p"
  silent! exe "set <F34>=\<Esc>\<C-?>"
  silent! exe "set <F35>=\<Esc>\<C-H>"
  silent! exe "set <F36>=\<Esc>q"
  silent! exe "set <F37>=\<Esc>l"
  " After F37 Vim stops mapping function keys man 5 terminfo lists function
  " keys going all the way up to F63, so it's unclear to me why Vim doesn't go
  " as far. Going down to the 20s seems to work. *shurgs*
  silent! exe "set <F21>=\<Esc>u"
  silent! exe "set <F22>=\<Esc>c"
  noremap!        <F29> <S-Left>
  noremap!        <F30> <S-Right>
  noremap!        <F31> <C-O>dw
  cnoremap        <F31> <S-Right><C-W>
  noremap!        <F32> <Down>
  noremap!        <F33> <Up>
  noremap!        <F34> <C-W>
  noremap!        <F35> <C-W>
  inoremap        <F36> <C-\><C-O>gwip
  nnoremap        <F36> gwip
  vnoremap        <F36> gw
  nnoremap        <F37> guew
  inoremap        <F37> <C-O>gue<C-O>w
  nnoremap        <F21> gUew
  inoremap        <F21> <C-O>gUe<C-O>w
  nnoremap        <F22> gUlw
  inoremap        <F22> <C-O>gUl<C-O>w

  if has('terminal')
    tnoremap      <F29> <Esc>b
    tnoremap      <F30> <Esc>f
    tnoremap      <F31> <Esc>d
    tnoremap      <F32> <Esc>n
    tnoremap      <F33> <Esc>p
    tnoremap      <F34> <Esc><C-?>
    tnoremap      <F35> <Esc><C-H>
    tnoremap      <F36> <Esc>q
    tnoremap      <F37> <Esc>l
    tnoremap      <F21> <Esc>u
    tnoremap      <F22> <Esc>c
  endif
  if &encoding ==# 'utf-8' && (has('unix') || has('win32'))
    try
      set encoding=cp949
      call s:MapMeta()
    finally
      set encoding=utf-8
    endtry
  else
    augroup rsi_gui
      autocmd!
      autocmd GUIEnter * call s:MapMeta()
    augroup END
  endif
endif

" vim:set et sw=2:
