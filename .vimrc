" Vundle {{{
set nocompatible
filetype off   
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" 操作
Plugin 'Townk/vim-autoclose' "自动插入添加匹配符号
Plugin 'vim-scripts/surround.vim' "符号处理
Plugin 'vim-scripts/tComment' "注释
Plugin 'terryma/vim-multiple-cursors' "多行选中
Plugin 'Valloric/YouCompleteMe'  "出现 python 之类的报错，一般在更新 python 后重新编译vim
Plugin 'google/yapf', { 'rtp': 'plugins/vim' } 

" snippets
Plugin 'honza/vim-snippets' 
Plugin 'SirVer/ultisnips' 

" 语法高亮
Plugin 'manzur/vim-java-syntax'
Plugin 'elzr/vim-json'
Plugin 'kelwin/vim-smali'
Plugin 'octol/vim-cpp-enhanced-highlight'

" 文件项目
Plugin 'scrooloose/nerdtree'
" Plugin 'danro/rename.vim'
Plugin 'majutsushi/tagbar'

" 外观
" Plugin 'Lokaltog/vim-powerline'
" Plugin 'vim-scripts/vimcdoc'
Plugin 'flazz/vim-colorschemes'
" Plugin 'altercation/vim-colors-solarized'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'godlygeek/tabular' " Code Format
" Plugin 'CodeFalling/fcitx-vim-osx' 
Plugin 'Yggdroot/indentLine'

call vundle#end()      

"Vundle }}}

"设置编码
set encoding=utf-8
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
set fileencodings=utf8,cp936,gb18030,big5
set ffs=unix,dos,mac "设置文件类型
set termencoding=utf8
set langmenu=zh_CN.UTF-8 "语言设置

filetype plugin indent on    
filetype on "打开文件类型自动检测功能
syntax enable
syntax on
set t_Co=256
set background=dark
" let g:solarized_termcolors=256
" colorscheme solarized
" colorscheme af
" colorscheme molokai
" colorscheme bubblegum-256-dark
" colorscheme Tomorrow-Night-Bright

set list lcs=tab:\|\ 

" 设置标记一列的背景颜色和数字一行颜色一致
hi! link SignColumn   LineNr
hi! link ShowMarksHLl DiffAdd
hi! link ShowMarksHLu DiffChange

set selectmode=mouse,key "可以在buffer的任何地方使用鼠标 set mouse=a set selection=exclusive
set showmatch "高亮显示匹配的括号
set nocompatible "去掉vi一致性
set history=1000 "设置VIM记录的历史数
set ambiwidth=double "设置ambiwidth

set incsearch "设置增量搜索模式
set ignorecase "搜索时大小写不敏感
" set hlsearch "高亮搜索

set modifiable "modify
" set clipboard=unnamed "vim 复制到clipboard

set nowrap " 禁止折行
set number "显示行号
set ruler
" set cursorline " 高亮当前行
" set cursorcolumn
set showtabline=2 "标签栏

"设置静音模式
set noerrorbells
set novisualbell

"不要备份文件
set nobackup
set nowb
set nowritebackup
set noswapfile

"设置缩进
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set cindent

"设置CSCOPE
set cscopequickfix=s-,c-,d-,i-,t-,e- "设定是否使用quickfix窗口显示cscope结果

"设置自动补全
set completeopt=longest,menuone
" 纠正选中回车 item 后的行为
inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"

"加载tags
if exists("tags")
	set tags=tags;/
endif

"设置当文件被外部改变的时侯自动读入文件
if exists("&autoread")
	set autoread
endif

"代码折叠
set foldmethod=marker " 基于缩进或语法进行代码折叠
" set foldmethod=syntax
" set foldmethod=indent
set nofoldenable " 启动 vim 时关闭折叠代码

" 按键调整
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-h> <C-w>h
map <C-l> <C-w>l
nnoremap <C-t>     :tabnew<CR>
inoremap <C-t>     <Esc>:tabnew<CR>

" w!! to sudo & write a file
cmap w!! w !sudo tee >/dev/null %

let g:pymode_python = 'python3'

" 更改<leader>前缀
let mapleader=";"

augroup filetypedetect
	au! BufNewFile,BufRead *.json			setfiletype json
	au! BufNewFile,BufRead *.md				setfiletype markdown
	au! BufNewFile,BufRead *.txt			setfiletype text
	au! BufNewFile,BufRead *.xyz			setfiletype drawing
	au! BufNewFile,BufRead *.log			setfiletype log
	au! BufNewFile,BufRead *.less			setfiletype less
	au! BufNewFile,BufRead .xinitrc 		setfiletype sh
	au! BufNewFile,BufRead *.rc				setfiletype sh
	au! BufNewFile,BufRead /etc/conf.d/*    setfiletype sh
	au! BufNewFile,BufRead *.sh				setfiletype sh
augroup end


" build system
set makeprg=make\ -C\ ../build\ -j9
map <F5> :make<CR>
map <F8> :w <CR> :!clear; g++ % -o %< && ./%< <CR>
""%" is taken the current file name.
"%<" is file name without extension.


"Plugin {{{

"powerline airline"""""
set noshowmode
set laststatus=2   " Always show the statusline
let g:airline_theme='term'
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:Powerline_symbols = 'fancy'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|' 

" NERDTree"""""
map <leader>n :NERDTreeToggle<CR>

" TagBar"""""
map <leader>t :TagbarToggle<CR>

" fzf插件"""""
set rtp+=/usr/local/Cellar/fzf/0.17.3
" Open files in horizontal split
nnoremap <silent> <Leader>s :call fzf#run({
			\   'down': '40%',
			\   'sink': 'botright split' })<CR>

" Open files in vertical horizontal split
nnoremap <silent> <Leader>v :call fzf#run({
			\   'right': winwidth('.') / 2,
			\   'sink':  'vertical botright split' })<CR>

nnoremap <silent> <Leader>e :call fzf#run({
			\   'down': '40%',
			\	'source': 'mdfind -onlyin ./ .',
			\   'sink': 'e' })<CR>

"Choose color scheme
nnoremap <silent> <Leader>C :call fzf#run({
			\   'source':
			\     map(split(globpath(&rtp, "colors/*.vim"), "\n"),
			\         "substitute(fnamemodify(v:val, ':t'), '\\..\\{-}$', '', '')"),
			\   'sink':    'colo',
			\   'options': '+m',
			\   'left':    30
			\ })<CR>

" Select buffer
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

" YouCompleteMe"""""
let g:ycm_filetype_blacklist = {
			\ 'tagbar' : 1,
			\ 'qf' : 1,
			\ 'notes' : 1,
			\ 'markdown' : 1,
			\ 'unite' : 1,
			\ 'text' : 1,
			\ 'vimwiki' : 1,
			\ 'gitcommit' : 1,
			\}
let g:ycm_global_ycm_extra_conf="/Users/hasky/.ycm_extra_conf.py"
" 这个快捷键与ultisnips冲突
" let g:ycm_key_list_select_completion=["<tab>"]
" let g:ycm_key_list_previous_completion=["<S-tab>"]
let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]
let g:ycm_path_to_python_interpreter="/usr/local/bin/python3"
map <C-]> :YcmCompleter GoToImprecise<CR>
" nnoremap <leader>gg :YcmCompleter GoToDefinitionElseDeclaration<CR>
nmap <F4> :YcmDiags<CR>

"  Ultisnips""""" (https://github.com/SirVer/ultisnips/issues/376)
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-tab>"
let g:UltiSnipsExpandTrigger="<nop>"
let g:ulti_expand_or_jump_res = 0
function! <SID>ExpandSnippetOrReturn()
	let snippet = UltiSnips#ExpandSnippetOrJump()
	if g:ulti_expand_or_jump_res > 0
		return snippet
	else
		return "\<CR>"
	endif
endfunction
inoremap <expr> <CR> pumvisible() ? "<C-R>=<SID>ExpandSnippetOrReturn()<CR>" : "\<CR>"

autocmd FileType python nnoremap <LocalLeader>= :0,$!yapf<CR>

" }}}
