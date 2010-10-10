" 
" init
"

set nocompatible    " vim 拡張機能ON
syntax on           " 色づけON
filetype on         
filetype indent on
filetype plugin on

" ディレクトリ設定
set backupdir=$HOME/tmp/vim/backup
set directory=$HOME/tmp/vim/swap

"
" エディタ設定
"

" 行番号を非表示 (number:表示)
set number
" tab表示文字数
set shiftwidth=4
set softtabstop=4
set expandtab
" <BS>で改行削除に
set backspace=indent,eol,start
" ステータスライン表示
set laststatus=2

" 以前開いていたときのカーソル位置を復元する
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

"
" encode
"
set encoding=utf-8
set fileencodings=utf-8,cp932,eucjp,iso2022jp
set fileformats=unix,dos,mac


"
" UI 設定
"

" 分割ウィンドウを(左ではなく)右に開くようにする
let g:netrw_altv=1
" ブラウザで <cr> を押してファイルを開くとき:新しいタブで開く
let g:netrw_browse_split=3
" ファイル一覧表示スタイル:long listing
let g:netrw_liststyle=1

"
" color
"
highlight Pmenu ctermbg=LightGray ctermfg=Black guibg=LightGray guifg=Black
highlight PmenuSel ctermbg=Blue guibg=RoyalBlue
highlight PmenuSbar ctermbg=LightGray guibg=LightGray
highlight PmenuThumb ctermbg=White guibg=White

" 全角空白と行末の空白の色を変える
highlight WideSpace ctermbg=blue guibg=blue
highlight EOLSpace ctermbg=red guibg=red

function! s:HighlightSpaces()
  syntax match WideSpace /　/ containedin=ALL
  syntax match EOLSpace /\s\+$/ containedin=ALL
endf

call s:HighlightSpaces()
autocmd WinEnter * call s:HighlightSpaces()

" 挿入モード時、ステータスラインの色を変える
autocmd InsertEnter * highlight StatusLine ctermfg=red guibg=red
autocmd InsertLeave * highlight StatusLine ctermfg=white guibg=white

"
" 検索
"

" 検索時に大文字小文字を無視
set ignorecase
" が、大文字が入っている場合は無視しない
set incsearch
" インクリメンタルサーチON
set incsearch
" ハイライトするが、ESC*2で消す
set hlsearch
nmap <Esc><Esc> :nohlsearch<CR><Esc>

"
" command line
"

" 補完候補表示
set wildmenu
" ステータス行フォーマット
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P

" クリップボードを貼り付け
map  <A-v> "+gP
imap <A-v> <ESC><ESC>"+gPa
cmap <A-v> <C-R>*

"<C-Space>でomni補完 
imap <C-Space> <C-x><C-o>

" Yで行末までヤンク
nnoremap Y y$
" これがないとyankringでYのmappingが上書きされて反映されない
function! YRRunAfterMaps()
    nnoremap Y   :<C-U>YRYankCount 'y$'<CR>
endfunction

" バッファ移動
map <F2> :bnext<CR>
map <F3> :bprevious<CR>

" テキスト整形
nmap Q JxVgq
vmap Q gq

" ファイルのディレクトリを補完
cmap <c-x> <c-r>=expand('%:p:h')<cr>\
" ファイルの絶対パスを補完
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
"<F5>でバッファのRubyスクリプトを実行し、結果をプレビュー表示
vmap <silent> <F5> :call Ruby_eval_vsplit()<CR>
nmap <silent> <F5> mzggVG<F5>`z
map  <silent> <S-F5> :pc<CR>
"<F6>でRubyスクリプトを保存後シンタックスチェックし、エラーをQuickFixに表示
nmap <silent> <F6> :w<CR>:make -c %<CR>:cw<CR>:cfirst<CR>zz
nmap <silent> <S-F6> :ccl<CR>
"<C-F5>でRubyスクリプトを保存後コマンドプロンプトから実行
nmap <silent> <C-F5> :w<CR>:!ruby %<CR>

" for YankRing.vim
helptags ~/.vim/doc
set viminfo+=!

"Rubyのオムニ補完を設定(ft-ruby-omni)
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1

if has('win32')
  " ヤンクしたときにもクリップボードへもヤンク
  set clipboard=unnamed
  " ヴィジュアルモードでヤンクしたときにも同様
"""set guioptions+=a
endif
