set nocompatible
filetype off                                                                                   "   required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'flazz/vim-colorschemes'
Plugin 'vim-scripts/vimcdoc'

Plugin 'Townk/vim-autoclose'
Plugin 'vim-scripts/surround.vim'
Plugin 'vim-scripts/tComment'
Plugin 'vim-scripts/taglist.vim'
Plugin 'terryma/vim-multiple-cursors'

Plugin 'vim-scripts/OmniCppComplete'
Plugin 'ervandew/supertab'
" Plugin 'vim-scripts/Javascript-OmniCompletion-with-YUI-and-j'
Plugin 'pangloss/vim-javascript'
Plugin 'manzur/vim-java-syntax'

" Plugin 'othree/javascript-libraries-syntax.vim'
Plugin 'elzr/vim-json'
Plugin 'kelwin/vim-smali'

" Plugin 'Lokaltog/vim-powerline'
Plugin 'bling/vim-airline'

Plugin 'scrooloose/nerdtree'
Plugin 'danro/rename.vim'

" Code Format
Plugin 'godlygeek/tabular'

call vundle#end()            " required
filetype plugin indent on    " required
" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 
"""""""""""""""""""""""""""""Vundle_above""""""""""""""""""""""""""""""""""" 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 

"设置编码
set encoding=utf-8
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
set fileencodings=utf8,cp936,gb18030,big5
set termencoding=utf8

"语言设置
set langmenu=zh_CN.UTF-8

"vimdoc语言
if version >= 603
	set helplang=cn
endif

"设置语法高亮
syntax enable
" 允许用指定语法高亮配色方案替换默认方案
syntax on
set background=light
" colorscheme 256-grayvim
colorscheme molokai

"可以在buffer的任何地方使用鼠标 set mouse=a set selection=exclusive
set selectmode=mouse,key

"高亮显示匹配的括号
set showmatch

"去掉vi一致性
set nocompatible

"设置缩进
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set cindent
" if $TERM == "xterm-256color"
	set t_Co=256
  " set t_ut=
" endif

"打开文件类型自动检测功能
filetype on

"设置taglist
let Tlist_Show_One_File=0   "显示多个文件的tags
let Tlist_File_Fold_Auto_Close=1 "非当前文件，函数列表折叠隐藏
let Tlist_Exit_OnlyWindow=1 "在taglist是最后一个窗口时退出vim
let Tlist_Use_SingleClick=1 "单击时跳转 let Tlist_GainFocus_On_ToggleOpen=1 "打开taglist时获得输入焦点
let Tlist_Process_File_Always=1 "不管taglist窗口是否打开，始终解析文件中的tag

"设置CSCOPE
set cscopequickfix=s-,c-,d-,i-,t-,e- "设定是否使用quickfix窗口显示cscope结果

"设置自动补全
filetype plugin indent on   "打开文件类型检测
set completeopt=longest,menu "关掉智能补全时的预览窗口

"启动vim时如果存在tags则自动加载
if exists("tags")
	set tags=./tags
endif

"设置默认shell
set shell=zsh

"设置VIM记录的历史数
set history=1000

"设置当文件被外部改变的时侯自动读入文件
if exists("&autoread")
	set autoread
endif

"设置ambiwidth
set ambiwidth=double

"设置文件类型
set ffs=unix,dos,mac

"设置增量搜索模式
set incsearch

"搜索时大小写不敏感
set ignorecase

" 禁止折行
set nowrap

"设置静音模式
set noerrorbells
set novisualbell
set t_vb=

"不要备份文件
set nobackup
set nowb
set nowritebackup
set noswapfile

"显示行号
set number

" 高亮当前行
set cursorline 
" hi CursorLine cterm=NONE ctermbg=blue ctermfg=white guibg=NONE guifg=NONE

set ruler

"modify
set modifiable

"代码折叠
" 基于缩进或语法进行代码折叠
"set foldmethod=marker
set foldmethod=indent
" set foldmethod=syntax
" 启动 vim 时关闭折叠代码
set nofoldenable
"
" switch window
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

"高亮搜索
" set hlsearch

"powerline airline
set noshowmode
set laststatus=2   " Always show the statusline
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:Powerline_symbols = 'fancy'
let g:airline_powerline_fonts = 1

" 更改<leader>前缀
let mapleader=","


au BufReadPost *.md set filetype=markdown

" C detection
augroup project
    autocmd!
    autocmd BufRead,BufNewFile *.h,*.c set filetype=c.doxygen
augroup END

" build system
set makeprg=make\ -C\ ../build\ -j9
map <F5> :make<CR>
""%" is taken the current file name.
"%<" is file name without extension.
map <F8> :w <CR> :!clear; cc % -o %< && ./%< <CR>
" imap jk <Esc>

"vim 复制到clipboard
set clipboard=unnamed

"--------------------------fzf插件--------------------------
set rtp+=/usr/local/bin/homebrew/Cellar/fzf/0.10.0
" Open files in horizontal split
nnoremap <silent> <Leader>s :call fzf#run({
\   'down': '40%',
\   'sink': 'botright split' })<CR>
" Open files in vertical horizontal split
nnoremap <silent> <Leader>v :call fzf#run({
\   'right': winwidth('.') / 2,
\   'sink':  'vertical botright split' })<CR>
" Choose color scheme
nnoremap <silent> <Leader>C :call fzf#run({
\   'source':
\     map(split(globpath(&rtp, "colors/*.vim"), "\n"),
\         "substitute(fnamemodify(v:val, ':t'), '\\..\\{-}$', '', '')"),
\   'sink':    'colo',
\   'options': '+m',
\   'left':    30
\ })<CR>
"Select buffer
function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:bufopen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction

nnoremap <silent> <Leader><Enter> :call fzf#run({
\   'source':  reverse(<sid>buflist()),
\   'sink':    function('<sid>bufopen'),
\   'options': '+m',
\   'down':    len(<sid>buflist()) + 2
\ })<CR>
"--------------------------fzf插件--------------------------
