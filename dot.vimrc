" 
" init
"

set nocompatible    " vim �g���@�\ON
syntax on           " �F�Â�ON
filetype on         
filetype indent on
filetype plugin on

" �f�B���N�g���ݒ�
set backupdir=$HOME/tmp/vim/backup
set directory=$HOME/tmp/vim/swap

"
" �G�f�B�^�ݒ�
"

" �s�ԍ����\�� (number:�\��)
set number
" tab�\��������
set shiftwidth=4
set softtabstop=4
set expandtab
" <BS>�ŉ��s�폜��
set backspace=indent,eol,start
" �X�e�[�^�X���C���\��
set laststatus=2

" �ȑO�J���Ă����Ƃ��̃J�[�\���ʒu�𕜌�����
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

"
" encode
"
set encoding=utf-8
set fileencodings=utf-8,cp932,eucjp,iso2022jp
set fileformats=unix,dos,mac


"
" UI �ݒ�
"

" �����E�B���h�E��(���ł͂Ȃ�)�E�ɊJ���悤�ɂ���
let g:netrw_altv=1
" �u���E�U�� <cr> �������ăt�@�C�����J���Ƃ�:�V�����^�u�ŊJ��
let g:netrw_browse_split=3
" �t�@�C���ꗗ�\���X�^�C��:long listing
let g:netrw_liststyle=1

"
" color
"
highlight Pmenu ctermbg=LightGray ctermfg=Black guibg=LightGray guifg=Black
highlight PmenuSel ctermbg=Blue guibg=RoyalBlue
highlight PmenuSbar ctermbg=LightGray guibg=LightGray
highlight PmenuThumb ctermbg=White guibg=White

" �S�p�󔒂ƍs���̋󔒂̐F��ς���
highlight WideSpace ctermbg=blue guibg=blue
highlight EOLSpace ctermbg=red guibg=red

function! s:HighlightSpaces()
  syntax match WideSpace /�@/ containedin=ALL
  syntax match EOLSpace /\s\+$/ containedin=ALL
endf

call s:HighlightSpaces()
autocmd WinEnter * call s:HighlightSpaces()

" �}�����[�h���A�X�e�[�^�X���C���̐F��ς���
autocmd InsertEnter * highlight StatusLine ctermfg=red guibg=red
autocmd InsertLeave * highlight StatusLine ctermfg=white guibg=white

"
" ����
"

" �������ɑ啶���������𖳎�
set ignorecase
" ���A�啶���������Ă���ꍇ�͖������Ȃ�
set incsearch
" �C���N�������^���T�[�`ON
set incsearch
" �n�C���C�g���邪�AESC*2�ŏ���
set hlsearch
nmap <Esc><Esc> :nohlsearch<CR><Esc>

"
" command line
"

" �⊮���\��
set wildmenu
" �X�e�[�^�X�s�t�H�[�}�b�g
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P

" �N���b�v�{�[�h��\��t��
map  <A-v> "+gP
imap <A-v> <ESC><ESC>"+gPa
cmap <A-v> <C-R>*

"<C-Space>��omni�⊮ 
imap <C-Space> <C-x><C-o>

" Y�ōs���܂Ń����N
nnoremap Y y$
" ���ꂪ�Ȃ���yankring��Y��mapping���㏑������Ĕ��f����Ȃ�
function! YRRunAfterMaps()
    nnoremap Y   :<C-U>YRYankCount 'y$'<CR>
endfunction

" �o�b�t�@�ړ�
map <F2> :bnext<CR>
map <F3> :bprevious<CR>

" �e�L�X�g���`
nmap Q JxVgq
vmap Q gq

" �t�@�C���̃f�B���N�g����⊮
cmap <c-x> <c-r>=expand('%:p:h')<cr>\
" �t�@�C���̐�΃p�X��⊮
cmap <c-z> <c-r>=expand('%:p:r')<cr>


"preview interpreter's output(Tip #1244)
function! Ruby_eval_vsplit() range
    if &filetype == "ruby"
        let src = tempname()
        let dst = "Ruby Output"
        " put current buffer's content in a temp file
        silent execute ": " . a:firstline . "," . a:lastline . "w " . src
        " open the preview window
        silent execute ":pedit! " . dst
        " change to preview window
        wincmd P
        " set options
        setlocal buftype=nofile
        setlocal noswapfile
        setlocal syntax=none
        setlocal bufhidden=delete
        " replace current buffer with ruby's output
        silent execute ":%! ruby " . src . " 2>&1 "
        " change back to the source buffer
        wincmd p
    endif
endfunction
"<F5>�Ńo�b�t�@��Ruby�X�N���v�g�����s���A���ʂ��v���r���[�\��
vmap <silent> <F5> :call Ruby_eval_vsplit()<CR>
nmap <silent> <F5> mzggVG<F5>`z
map  <silent> <S-F5> :pc<CR>
"<F6>��Ruby�X�N���v�g��ۑ���V���^�b�N�X�`�F�b�N���A�G���[��QuickFix�ɕ\��
nmap <silent> <F6> :w<CR>:make -c %<CR>:cw<CR>:cfirst<CR>zz
nmap <silent> <S-F6> :ccl<CR>
"<C-F5>��Ruby�X�N���v�g��ۑ���R�}���h�v�����v�g������s
nmap <silent> <C-F5> :w<CR>:!ruby %<CR>

" for YankRing.vim
helptags ~/.vim/doc
set viminfo+=!

"Ruby�̃I���j�⊮��ݒ�(ft-ruby-omni)
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1

if has('win32')
  " �����N�����Ƃ��ɂ��N���b�v�{�[�h�ւ������N
  set clipboard=unnamed
  " ���B�W���A�����[�h�Ń����N�����Ƃ��ɂ����l
"""set guioptions+=a
endif
