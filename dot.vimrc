"
" init
"

" for MacVim-KaoryYa
" http://blogger.splhack.org/2010/11/macvim-kaoriya-20101102.html
if has('kaoriya')
  let $RUBY_DLL="/usr/lib/libruby.dylib"
endif

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
" バッファを切り替えてもundo等がリセットされないように
set hidden

" 以前開いていたときのカーソル位置を復元する
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

"
" encode
"
set encoding=utf-8
set fileformats=unix,dos,mac

" gauche_guess により、自動的に文字コードの判別を行います。
" fileencodings(fencs) は設定不要です。
" .vimrcなどでfileencodings(fencs)を設定すると文字コード判別が動作しなくなります。
if !has('kaoriya')
  set fileencodings=utf-8,cp932,eucjp,iso2022jp
endif

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
function! ActivateInvisibleIndicator()
    " 全角スペース　のハイライトが効かない。。
    syntax match InvisibleJISX0208Space "　" display containedin=ALL
    highlight InvisibleJISX0208Space term=underline ctermbg=Red guibg=Red
    syntax match InvisibleTrailedSpace "[ \t]\+$" display containedin=ALL
    highlight InvisibleTrailedSpace term=underline ctermbg=Red guibg=Red
endf
augroup invisible
    autocmd! invisible
    autocmd BufNew,BufRead * call ActivateInvisibleIndicator()
augroup END


" 挿入モード時、ステータスラインの色を変える
autocmd InsertEnter * highlight StatusLine ctermfg=red guibg=red
autocmd InsertLeave * highlight StatusLine ctermfg=white guibg=white

" カーソル行をハイライト
set cursorline
highlight CursorLine cterm=underline gui=underline guibg=NONE

"
" 検索
"

" 検索時に大文字小文字を無視
set ignorecase
" が、大文字が入っている場合は無視しない
set smartcase
" インクリメンタルサーチON
set incsearch
" ハイライトするが、ESC*2で消す
set hlsearch
nmap <Esc><Esc> :nohlsearch<CR><Esc>
" migemo設定
" @see http://code.google.com/p/macvim-kaoriya/issues/detail?id=16
if has ('migemo')
    set migemo
    set migemodict=$VIMRUNTIME/dict/migemo-dict
endif

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
map <C-L> :bnext<CR>
map <C-H> :bprevious<CR>

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

" Alignを日本語環境で使用するための設定
let g:Align_xstrlen = 3

" Read Template
"function read_template
"    let list = expand("$HOME/.vim/template/*.txt")
"    let items = split(list, "\n")
"    for item in items
"        tpl = split(item, '\.')[0]
"        execute "autocmd BuffNewFile *." . tpl . "0r " . item
"    endfor
"endfunction
"call read_template()
autocmd BufNewFile *.html 0r $HOME/.vim/template/html.txt
autocmd BufNewFile *.rb   0r $HOME/.vim/template/rb.txt
autocmd BufNewFile *.erb  0r $HOME/.vim/template/html.txt

"
" Tohtml option
"
let g:use_xhtml = 1
let g:html_use_css = 1
let g:html_no_pre = 1

"
" neocomplcache
"
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_underbar_completion = 1
"let g:neocomplcache_min_syntax_length = 3 "default 4
" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

if has('win32')
  " ヤンクしたときにもクリップボードへもヤンク
  set clipboard=unnamed
  " ヴィジュアルモードでヤンクしたときにも同様
"""set guioptions+=a
endif
