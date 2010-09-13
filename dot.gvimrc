" カラースキーマ設定
colorscheme bensday

set guioptions-=aegimrLtT

" カーソル行をハイライト
highlight CursorLine guibg=gray20

" タブ移動
map <C-L> gt
map <C-H> gT

" 終了時の位置、サイズを記憶
let g:save_window_file = expand('~/.vimwinpos')
augroup SaveWindow
  autocmd!
  autocmd VimLeavePre * call s:save_window()
  function! s:save_window()
    let options = [
      \ 'set columns=' . &columns,
      \ 'set lines=' . &lines,
      \ 'winpos ' . getwinposx() . ' ' . getwinposy(),
      \ ]
    call writefile(options, g:save_window_file)
  endfunction
augroup END

if filereadable(g:save_window_file)
  execute 'source' g:save_window_file
endif

"
" OS毎の設定
"

" font
if has('win32')
  " Windows用
  set guifont=MeiryoKe_Gothic:h10.5:cSHIFTJIS
  if has('printer')
    set printfont=MeiryoKe_Gothic:h10.5:cSHIFTJIS
  endif
endif

if has('gui_macvim')
  " 透明度
  set transparency=5
end
