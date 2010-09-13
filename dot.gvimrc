" �J���[�X�L�[�}�ݒ�
colorscheme bensday

set guioptions-=aegimrLtT

" �J�[�\���s���n�C���C�g
highlight CursorLine guibg=gray20

" �^�u�ړ�
map <C-L> gt
map <C-H> gT

" �I�����̈ʒu�A�T�C�Y���L��
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
" OS���̐ݒ�
"

" font
if has('win32')
  " Windows�p
  set guifont=MeiryoKe_Gothic:h10.5:cSHIFTJIS
  if has('printer')
    set printfont=MeiryoKe_Gothic:h10.5:cSHIFTJIS
  endif
endif

if has('gui_macvim')
  " �����x
  set transparency=5
end
