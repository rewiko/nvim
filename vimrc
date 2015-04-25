" detect OS {{{
	let s:is_windows = has('win32') || has('win64')
	let s:is_cygwin = has('win32unix')
	let s:is_macvim = has('gui_macvim')
"}}}

" dotvim settings {{{
	if !exists('g:dotvim_settings') || !exists('g:dotvim_settings.version')
		echom 'The g:dotvim_settings and g:dotvim_settings.version variables must be defined.  Please consult the README.'
		finish
	endif

	let s:cache_dir = get(g:dotvim_settings, 'cache_dir', '~/.vim/.cache')

	if g:dotvim_settings.version != 1
		echom 'The version number in your shim does not match the distribution version.  Please consult the README changelog section.'
		finish
	endif

	" initialize default settings
	let s:settings = {}
	let s:settings.default_indent = 2
	let s:settings.max_column = 120
	let s:settings.autocomplete_method = 'neocomplcache'
	let s:settings.enable_cursorcolumn = 0
	let s:settings.colorscheme = 'jellybeans'
	if has('python') && filereadable(expand("~/.vim/bundle/YouCompleteMe/third_party/ycmd/ycm_core.so")) && filereadable(expand("~/.vim/bundle/YouCompleteMe/third_party/ycmd/ycm_client_support.so"))
		let s:settings.autocomplete_method = 'ycm'
	elseif has('lua')
		let s:settings.autocomplete_method = 'neocomplete'
	endif

	if exists('g:dotvim_settings.plugin_groups')
		let s:settings.plugin_groups = g:dotvim_settings.plugin_groups
	else
		let s:settings.plugin_groups = []
		call add(s:settings.plugin_groups, 'core')
		call add(s:settings.plugin_groups, 'web')
		call add(s:settings.plugin_groups, 'language')
		call add(s:settings.plugin_groups, 'c')
		call add(s:settings.plugin_groups, 'javascript')
		call add(s:settings.plugin_groups, 'ruby')
		call add(s:settings.plugin_groups, 'python')
		call add(s:settings.plugin_groups, 'scala')
		call add(s:settings.plugin_groups, 'go')
		call add(s:settings.plugin_groups, 'scm')
		call add(s:settings.plugin_groups, 'editing')
		call add(s:settings.plugin_groups, 'indents')
		call add(s:settings.plugin_groups, 'navigation')
		call add(s:settings.plugin_groups, 'unite')
		call add(s:settings.plugin_groups, 'autocomplete')
		" call add(s:settings.plugin_groups, 'textobj')
		call add(s:settings.plugin_groups, 'misc')
		if s:is_windows
			call add(s:settings.plugin_groups, 'windows')
		endif

		" exclude all language-specific plugins by default
		if !exists('g:dotvim_settings.plugin_groups_exclude')
			let g:dotvim_settings.plugin_groups_exclude = ['web','javascript','ruby','python','go','scala']
		endif
		for group in g:dotvim_settings.plugin_groups_exclude
			let i = index(s:settings.plugin_groups, group)
			if i != -1
				call remove(s:settings.plugin_groups, i)
			endif
		endfor

		if exists('g:dotvim_settings.plugin_groups_include')
			for group in g:dotvim_settings.plugin_groups_include
				call add(s:settings.plugin_groups, group)
			endfor
		endif
	endif

	" override defaults with the ones specified in g:dotvim_settings
	for key in keys(s:settings)
		if has_key(g:dotvim_settings, key)
			let s:settings[key] = g:dotvim_settings[key]
		endif
	endfor
"}}}

" setup & neobundle {{{
	set nocompatible
	set all& "reset everything to their defaults
	if s:is_windows
		set rtp+=~/.vim
	endif
	set rtp+=~/.vim/bundle/neobundle.vim
	call neobundle#begin(expand('~/.vim/bundle/'))
	NeoBundleFetch 'Shougo/neobundle.vim'
	NeoBundleLocal ~/.vim/bundle_dev
"}}}

" functions {{{
	function! s:get_cache_dir(suffix) "{{{
		return resolve(expand(s:cache_dir . '/' . a:suffix))
	endfunction "}}}
	function! Source(begin, end) "{{{
		let lines = getline(a:begin, a:end)
		for line in lines
			execute line
		endfor
	endfunction "}}}
	function! Preserve(command) "{{{
		" preparation: save last search, and cursor position.
		let _s=@/
		let l = line(".")
		let c = col(".")
		" do the business:
		execute a:command
		" clean up: restore previous search history, and cursor position
		let @/=_s
		call cursor(l, c)
	endfunction "}}}
	function! StripTrailingWhitespace() "{{{
		call Preserve("%s/\\s\\+$//e")
	endfunction "}}}
	function! EnsureExists(path) "{{{
		if !isdirectory(expand(a:path))
			call mkdir(expand(a:path))
		endif
	endfunction "}}}
	function! CloseWindowOrKillBuffer() "{{{
		let number_of_windows_to_this_buffer = len(filter(range(1, winnr('$')), "winbufnr(v:val) == bufnr('%')"))

		" never bdelete a nerd tree
		if matchstr(expand("%"), 'NERD') == 'NERD'
			wincmd c
			return
		endif

		if number_of_windows_to_this_buffer > 1
			wincmd c
		else
			bdelete
		endif
	endfunction "}}}
"}}}

" base configuration {{{
	set timeoutlen=300	"mapping timeout
	set ttimeoutlen=50	"keycode timeout

	set mouse=a	"enable mouse
	set mousehide	"hide when characters are typed
	set history=1000	"number of command lines to remember
	set ttyfast	"assume fast terminal connection
	set viewoptions=folds,options,cursor,unix,slash	"unix/windows compatibility
	if exists('$TMUX')
		set clipboard=
	else
		set clipboard=unnamed	"sync with OS clipboard
	endif
	set hidden	"allow buffer switching without saving
	set autoread	"auto reload if file saved externally
	set fileformats+=mac	"add mac to auto-detection of file format line endings
	set nrformats-=octal	"always assume decimal numbers
	set showcmd
	set tags=tags;/
	set showfulltag
	set modeline
	set modelines=5

	if s:is_windows && !s:is_cygwin
		" ensure correct shell in gvim
		set shell=c:\windows\system32\cmd.exe
	endif

	if $SHELL =~ '/fish$'
		" VIM expects to be run from a POSIX shell.
		set shell=sh
	endif

	set noshelltemp	"use pipes

	" whitespace
	set backspace=indent,eol,start	"allow backspacing everything in insert mode
	set autoindent	"automatically indent to match adjacent lines
	set expandtab	"spaces instead of tabs
	set smarttab	"use shiftwidth to enter tabs
	let &tabstop=s:settings.default_indent	"number of spaces per tab for display
	let &softtabstop=s:settings.default_indent	"number of spaces per tab in insert mode
	let &shiftwidth=s:settings.default_indent	"number of spaces when indenting
	set list	"highlight whitespace
	set shiftround
	set linebreak

	set scrolloff=1	"always show content after scroll
	set scrolljump=5	"minimum number of lines to scroll
	set display+=lastline
	set wildmenu	"show list for autocomplete
	set wildmode=list:full
	if (v:version >= 704)
		set wildignorecase
	endif

	set splitbelow
	set splitright

	" disable sounds
	set noerrorbells
	set novisualbell
	set t_vb=

	" searching
	set hlsearch	"highlight searches
	set incsearch	"incremental searching
	set ignorecase	"ignore case for searching
	set smartcase	"do case-sensitive if there's a capital letter
	if executable('ack')
		set grepprg=ack\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow\ $*
		set grepformat=%f:%l:%c:%m
	endif
	if executable('ag')
		set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow
		set grepformat=%f:%l:%c:%m
	endif

	" vim file/folder management {{{
		" persistent undo
		if exists('+undofile')
			set undofile
			let &undodir = s:get_cache_dir('undo')
		endif

		" backups
		set backup
		let &backupdir = s:get_cache_dir('backup')

		" swap files
		let &directory = s:get_cache_dir('swap')
		set noswapfile

		call EnsureExists(s:cache_dir)
		call EnsureExists(&undodir)
		call EnsureExists(&backupdir)
		call EnsureExists(&directory)
	"}}}

	let mapleader = ","
	let g:mapleader = ","
"}}}

" ui configuration {{{
	set showmatch	"automatically highlight matching braces/brackets/etc.
	set matchtime=2	"tens of a second to show matching parentheses
	set number
	set lazyredraw
	set laststatus=2
	set noshowmode
	set foldenable	"enable folds by default
	set foldmethod=syntax	"fold via syntax of files
	set foldlevelstart=99	"open all folds by default
	let g:xml_syntax_folding=1	"enable xml folding

	set cursorline
	autocmd WinLeave * setlocal nocursorline
	autocmd WinEnter * setlocal cursorline
	let &colorcolumn=s:settings.max_column
	if s:settings.enable_cursorcolumn
		set cursorcolumn
		autocmd WinLeave * setlocal nocursorcolumn
		autocmd WinEnter * setlocal cursorcolumn
	endif

	if has('gui_running')
		" open maximized
		set lines=999 columns=9999
		if s:is_windows
			autocmd GUIEnter * simalt ~x
		endif

		set guioptions+=t	"tear off menu items
		set guioptions-=T	"toolbar icons

		if s:is_macvim
			set gfn=Ubuntu_Mono:h14
			set transparency=2
		endif

		if s:is_windows
			set gfn=Ubuntu_Mono:h10
		endif

		if has('gui_gtk')
			set gfn=Ubuntu\ Mono\ 11
		endif
	else
		if $COLORTERM == 'gnome-terminal'
			set t_Co=256 "why you no tell me correct colors?!?!
		endif
		if $TERM_PROGRAM == 'iTerm.app'
			" different cursors for insert vs normal mode
			if exists('$TMUX')
				let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
				let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
			else
				let &t_SI = "\<Esc>]50;CursorShape=1\x7"
				let &t_EI = "\<Esc>]50;CursorShape=0\x7"
			endif
		endif
	endif
"}}}

" plugin/mapping configuration {{{
	if count(s:settings.plugin_groups, 'core') "{{{
		NeoBundle 'matchit.zip'
		NeoBundle 'bling/vim-airline' "{{{
			let g:airline#extensions#tabline#enabled = 1
			let g:airline#extensions#tabline#left_sep = ' '
			let g:airline#extensions#tabline#left_alt_sep = '¦'
		"}}}
		NeoBundle 'tpope/vim-surround'
		NeoBundle 'tpope/vim-repeat'
		NeoBundle 'tpope/vim-dispatch'
		NeoBundle 'tpope/vim-eunuch'
		NeoBundle 'tpope/vim-unimpaired' "{{{
			nmap <C-Up> [e
			nmap <C-Down> ]e
			vmap <C-Up> [egv
			vmap <C-Down> ]egv
		"}}}
		NeoBundle 'Shougo/vimproc.vim', {
			\ 'build': {
				\ 'mac': 'make -f make_mac.mak',
				\ 'unix': 'make -f make_unix.mak',
				\ 'cygwin': 'make -f make_cygwin.mak',
				\ 'windows': '"C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\bin\nmake.exe" make_msvc32.mak',
			\ },
		\ }
	endif "}}}
	if count(s:settings.plugin_groups, 'web') "{{{
		NeoBundleLazy 'groenewege/vim-less', {'autoload':{'filetypes':['less']}}
		NeoBundleLazy 'cakebaker/scss-syntax.vim', {'autoload':{'filetypes':['scss','sass']}}
		NeoBundleLazy 'hail2u/vim-css3-syntax', {'autoload':{'filetypes':['css','scss','sass']}}
		NeoBundleLazy 'ap/vim-css-color', {'autoload':{'filetypes':['css','scss','sass','less','styl']}}
		NeoBundleLazy 'othree/html5.vim', {'autoload':{'filetypes':['html']}}
		NeoBundleLazy 'wavded/vim-stylus', {'autoload':{'filetypes':['styl']}}
		NeoBundleLazy 'digitaltoad/vim-jade', {'autoload':{'filetypes':['jade']}}
		NeoBundleLazy 'juvenn/mustache.vim', {'autoload':{'filetypes':['mustache']}}
		NeoBundleLazy 'gregsexton/MatchTag', {'autoload':{'filetypes':['html','xml']}}
		NeoBundleLazy 'mattn/emmet-vim', {'autoload':{'filetypes':['html','xml','xsl','xslt','xsd','css','sass','scss','less','mustache']}} "{{{
			function! s:zen_html_tab()
				let line = getline('.')
				if match(line, '<.*>') < 0
					return "\<C-y>,"
				endif
				return "\<C-y>n"
			endfunction
			autocmd FileType xml,xsl,xslt,xsd,css,sass,scss,less,mustache imap <buffer><Tab> <C-y>,
			autocmd FileType html imap <buffer><expr><Tab> <SID>zen_html_tab()
		"}}}
	endif "}}}
	if count(s:settings.plugin_groups, 'language') "{{{
		" run `:UpdateTypesFile` to highlight ctags symbols
		NeoBundle 'TagHighlight'
		NeoBundle 'gtags.vim'
		NeoBundle 'gdbmgr'
	endif "}}}
	if count(s:settings.plugin_groups, 'c') "{{{
		NeoBundleLazy 'a.vim', {'autoload':{'filetypes':['c','cpp']}}
		NeoBundleLazy 'c.vim', {'autoload':{'filetypes':['c','cpp']}}
		NeoBundleLazy 'echofunc.vim', {'autoload':{'filetypes':['c','cpp']}}
		NeoBundleLazy 'STL-improved', {'autoload':{'filetypes':['c','cpp']}}
	endif "}}}
	if count(s:settings.plugin_groups, 'javascript') "{{{
		NeoBundleLazy 'marijnh/tern_for_vim', {
			\ 'autoload':{ 'filetypes': ['javascript'] },
			\ 'build':{
				\ 'mac': 'npm install',
				\ 'unix': 'npm install',
				\ 'cygwin': 'npm install',
				\ 'windows': 'npm install',
			\ },
		\ }
		NeoBundleLazy 'pangloss/vim-javascript', {'autoload':{'filetypes':['javascript']}}
		NeoBundleLazy 'maksimr/vim-jsbeautify', {'autoload':{'filetypes':['javascript']}} "{{{
			nnoremap <Leader>fjs :call JsBeautify()<CR>
		"}}}
		NeoBundleLazy 'leafgarland/typescript-vim', {'autoload':{'filetypes':['typescript']}}
		NeoBundleLazy 'kchmck/vim-coffee-script', {'autoload':{'filetypes':['coffee']}}
		NeoBundleLazy 'mmalecki/vim-node.js', {'autoload':{'filetypes':['javascript']}}
		NeoBundleLazy 'leshill/vim-json', {'autoload':{'filetypes':['javascript','json']}}
		NeoBundleLazy 'othree/javascript-libraries-syntax.vim', {'autoload':{'filetypes':['javascript','coffee','ls','typescript']}}
	endif "}}}
	if count(s:settings.plugin_groups, 'ruby') "{{{
		NeoBundle 'tpope/vim-rails'
		NeoBundle 'tpope/vim-bundler'
	endif "}}}
	if count(s:settings.plugin_groups, 'python') "{{{
		NeoBundleLazy 'klen/python-mode', {'autoload':{'filetypes':['python']}} "{{{
			let g:pymode_rope=0
		"}}}
		NeoBundleLazy 'davidhalter/jedi-vim', {'autoload':{'filetypes':['python']}} "{{{
			let g:jedi#popup_on_dot=0
		"}}}
	endif "}}}
	if count(s:settings.plugin_groups, 'scala') "{{{
		NeoBundle 'derekwyatt/vim-scala'
		NeoBundle 'megaannum/vimside'
	endif "}}}
	if count(s:settings.plugin_groups, 'go') "{{{
		NeoBundleLazy 'jnwhiteh/vim-golang', {'autoload':{'filetypes':['go']}}
		NeoBundleLazy 'nsf/gocode', {'autoload':{'filetypes':['go']},'rtp': 'vim'}
	endif "}}}
	if count(s:settings.plugin_groups, 'scm') "{{{
		NeoBundle 'mhinz/vim-signify' "{{{
			let g:signify_update_on_bufenter=0
		"}}}
		if executable('hg')
			NeoBundle 'bitbucket:ludovicchabant/vim-lawrencium'
		endif
		NeoBundle 'tpope/vim-fugitive' "{{{
			nnoremap <silent> <Leader>gs :Gstatus<CR>
			nnoremap <silent> <Leader>gd :Gdiff<CR>
			nnoremap <silent> <Leader>gc :Gcommit<CR>
			nnoremap <silent> <Leader>gb :Gblame<CR>
			nnoremap <silent> <Leader>gl :Glog<CR>
			nnoremap <silent> <Leader>gp :Git push<CR>
			nnoremap <silent> <Leader>gw :Gwrite<CR>
			nnoremap <silent> <Leader>gr :Gremove<CR>
			autocmd BufReadPost fugitive://* set bufhidden=delete
		"}}}
		NeoBundleLazy 'gregsexton/gitv', {'depends':['tpope/vim-fugitive'],'autoload':{'commands':'Gitv'}} "{{{
			nnoremap <silent> <Leader>gv :Gitv<CR>
			nnoremap <silent> <Leader>gV :Gitv!<CR>
		"}}}
	endif "}}}
	if count(s:settings.plugin_groups, 'autocomplete') "{{{
		NeoBundle 'honza/vim-snippets'
		if s:settings.autocomplete_method == 'ycm' "{{{
			NeoBundle 'Valloric/YouCompleteMe', {'vim_version':'7.3.584'} "{{{
				"let g:ycm_path_to_python_interpreter='~/local/bin/python'
				let g:ycm_complete_in_comments_and_strings=1
				let g:ycm_key_list_select_completion=['<C-n>','<Down>']
				let g:ycm_key_list_previous_completion=['<C-p>','<Up>']
				let g:ycm_filetype_blacklist={'unite': 1}
			"}}}
			NeoBundle 'SirVer/ultisnips' "{{{
				let g:UltiSnipsExpandTrigger="<Tab>"
				let g:UltiSnipsJumpForwardTrigger="<Tab>"
				let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"
				let g:UltiSnipsSnippetsDir='~/.vim/snippets'
			"}}}
		else
			NeoBundle 'Shougo/neosnippet-snippets'
			NeoBundle 'Shougo/neosnippet.vim' "{{{
				let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets,~/.vim/snippets'
				let g:neosnippet#enable_snipmate_compatibility=1

				imap <expr><Tab> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ? "\<C-n>" : "\<Tab>")
				smap <expr><Tab> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"
				imap <expr><S-Tab> pumvisible() ? "\<C-p>" : ""
				smap <expr><S-Tab> pumvisible() ? "\<C-p>" : ""
			"}}}
		endif "}}}
		if s:settings.autocomplete_method == 'neocomplete' "{{{
			NeoBundleLazy 'Shougo/neocomplete.vim', {'autoload':{'insert':1},'vim_version':'7.3.885'} "{{{
				let g:neocomplete#enable_at_startup=1
				let g:neocomplete#data_directory=s:get_cache_dir('neocomplete')
			"}}}
		endif "}}}
		if s:settings.autocomplete_method == 'neocomplcache' "{{{
			NeoBundleLazy 'Shougo/neocomplcache.vim', {'autoload':{'insert':1}} "{{{
				let g:neocomplcache_enable_at_startup=1
				let g:neocomplcache_temporary_dir=s:get_cache_dir('neocomplcache')
				let g:neocomplcache_enable_fuzzy_completion=1
			"}}}
		endif "}}}
	endif "}}}
	if count(s:settings.plugin_groups, 'editing') "{{{
		NeoBundleLazy 'editorconfig/editorconfig-vim', {'autoload':{'insert':1}}
		NeoBundle 'tpope/vim-endwise'
		NeoBundle 'tpope/vim-speeddating'
		NeoBundle 'thinca/vim-visualstar'
		NeoBundle 'tomtom/tcomment_vim'
		NeoBundle 'terryma/vim-expand-region'
		NeoBundle 'terryma/vim-multiple-cursors'
		NeoBundle 'chrisbra/NrrwRgn'
		NeoBundleLazy 'godlygeek/tabular', {'autoload':{'commands':'Tabularize'}} "{{{
			nmap <Leader>a& :Tabularize /&<CR>
			vmap <Leader>a& :Tabularize /&<CR>
			nmap <Leader>a= :Tabularize /=<CR>
			vmap <Leader>a= :Tabularize /=<CR>
			nmap <Leader>a: :Tabularize /:<CR>
			vmap <Leader>a: :Tabularize /:<CR>
			nmap <Leader>a:: :Tabularize /:\zs<CR>
			vmap <Leader>a:: :Tabularize /:\zs<CR>
			nmap <Leader>a, :Tabularize /,<CR>
			vmap <Leader>a, :Tabularize /,<CR>
			nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
			vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
		"}}}
		NeoBundle 'jiangmiao/auto-pairs'
		NeoBundle 'justinmk/vim-sneak' "{{{
			let g:sneak#streak = 1
		"}}}
	endif "}}}
	if count(s:settings.plugin_groups, 'navigation') "{{{
		NeoBundle 'mileszs/ack.vim' "{{{
			if executable('ag')
				let g:ackprg = "ag --nogroup --column --smart-case --follow"
			endif
		"}}}
		NeoBundleLazy 'mbbill/undotree', {'autoload':{'commands':'UndotreeToggle'}} "{{{
			let g:undotree_SplitLocation='botright'
			let g:undotree_SetFocusWhenToggle=1
			nnoremap <silent> <Leader>u :UndotreeToggle<CR>
		"}}}
		NeoBundleLazy 'EasyGrep', {'autoload':{'commands':'GrepOptions'}} "{{{
			let g:EasyGrepRecursive=1
			let g:EasyGrepAllOptionsInExplorer=1
			let g:EasyGrepCommand=1
			nnoremap <Leader>vo :GrepOptions<CR>
		"}}}
		NeoBundleLazy 'ctrlpvim/ctrlp.vim', {'depends':'tacahiroy/ctrlp-funky','autoload':{'commands':'CtrlP'}} "{{{
			let g:ctrlp_clear_cache_on_exit=1
			let g:ctrlp_max_height=40
			let g:ctrlp_show_hidden=0
			let g:ctrlp_follow_symlinks=1
			let g:ctrlp_max_files=20000
			let g:ctrlp_cache_dir=s:get_cache_dir('ctrlp')
			let g:ctrlp_reuse_window='startify'
			let g:ctrlp_extensions=['funky']
			let g:ctrlp_custom_ignore = {
						\ 'dir': '\v[\/]\.(git|hg|svn|idea)$',
						\ 'file': '\v\.DS_Store$'
						\ }

			if executable('ag')
				let g:ctrlp_user_command='ag %s -l --nocolor -g ""'
			endif

			nmap \ [ctrlp]
			nnoremap [ctrlp] <Nop>

			nnoremap [ctrlp]t :CtrlPBufTag<CR>
			nnoremap [ctrlp]T :CtrlPTag<CR>
			nnoremap [ctrlp]l :CtrlPLine<CR>
			nnoremap [ctrlp]o :CtrlPFunky<CR>
			nnoremap [ctrlp]b :CtrlPBuffer<CR>
		"}}}
		"NeoBundleLazy 'scrooloose/nerdtree', {'autoload':{'commands':['NERDTreeToggle','NERDTreeFind']}} "{{{
		NeoBundle 'scrooloose/nerdtree' "{{{
			let NERDTreeShowHidden=1
			let NERDTreeQuitOnOpen=0
			let NERDTreeShowLineNumbers=1
			let NERDTreeChDirMode=0
			let NERDTreeShowBookmarks=1
			let NERDTreeIgnore=['\.git','\.hg']
			let NERDTreeBookmarksFile=s:get_cache_dir('NERDTreeBookmarks')
			nnoremap <silent> <Leader>n :NERDTreeToggle<CR>
			nnoremap <silent> <Leader>nf :NERDTreeFind<CR>
		"}}}
		NeoBundleLazy 'majutsushi/tagbar', {'autoload':{'commands':'TagbarToggle'}} "{{{
			nnoremap <silent> <Leader>ta :TagbarToggle<CR>
		"}}}
		NeoBundle 'jeetsukumaran/vim-buffergator' "{{{
			"let g:buffergator_suppress_keymaps = 1
			let g:buffergator_suppress_mru_switch_into_splits_keymaps = 1
			let g:buffergator_viewport_split_policy = "B"
			let g:buffergator_split_size = 10
			let g:buffergator_sort_regime = "mru"
			let g:buffergator_mru_cycle_loop = 0
			"nnoremap <silent> <Leader>b :BuffergatorOpen<CR>
			"nnoremap <silent> <Leader>B :BuffergatorClose<CR>
			"nnoremap <silent> <M-b> :BuffergatorMruCyclePrev<CR>
			"nnoremap <silent> <M-S-b> :BuffergatorMruCycleNext<CR>
			"nnoremap <silent> [b :BuffergatorMruCyclePrev<CR>
			"nnoremap <silent> ]b :BuffergatorMruCycleNext<CR>
		"}}}
	endif "}}}
	if count(s:settings.plugin_groups, 'unite') "{{{
		NeoBundle 'Shougo/unite.vim' "{{{
			let bundle = neobundle#get('unite.vim')
			function! bundle.hooks.on_source(bundle)
				call unite#filters#matcher_default#use(['matcher_fuzzy'])
				call unite#filters#sorter_default#use(['sorter_rank'])
				call unite#custom#source('file_rec,file_rec/async', 'ignore_pattern', '\.svn/\|\.tags$\|cscope\.\|\.taghl$')
				call unite#custom#profile('default', 'context', {
							\ 'start_insert': 1
							\ })
			endfunction

			let g:unite_data_directory=s:get_cache_dir('unite')
			let g:unite_source_history_yank_enable=1
			let g:unite_source_rec_max_cache_files=5000

			if executable('ag')
				let g:unite_source_grep_command='ag'
				let g:unite_source_grep_default_opts='--nocolor --line-numbers --nogroup -S -C4'
				let g:unite_source_grep_recursive_opt=''
			elseif executable('ack')
				let g:unite_source_grep_command='ack'
				let g:unite_source_grep_default_opts='--no-heading --no-color -C4'
				let g:unite_source_grep_recursive_opt=''
			endif

			function! s:unite_settings()
				nmap <buffer> Q <Plug>(unite_exit)
				nmap <buffer> <Esc> <Plug>(unite_exit)
				imap <buffer> <Esc> <Plug>(unite_exit)
			endfunction
			autocmd FileType unite call s:unite_settings()

			nmap <Space> [unite]
			nnoremap [unite] <Nop>

			if s:is_windows
				nnoremap <silent> [unite]<Space> :<C-u>Unite -toggle -auto-resize -buffer-name=mixed buffer file:! file_mru bookmark<CR><C-u>
				nnoremap <silent> [unite]f :<C-u>Unite -toggle -auto-resize -buffer-name=files file:!<CR><C-u>
			else
				nnoremap <silent> [unite]<Space> :<C-u>Unite -toggle -auto-resize -buffer-name=mixed buffer file/async:! file_mru bookmark<CR><C-u>
				nnoremap <silent> [unite]f :<C-u>Unite -toggle -auto-resize -buffer-name=files file/async:!<CR><C-u>
			endif
			nnoremap <silent> [unite]e :<C-u>Unite -buffer-name=recent file_mru<CR>
			nnoremap <silent> [unite]y :<C-u>Unite -buffer-name=yanks history/yank<CR>
			nnoremap <silent> [unite]l :<C-u>Unite -auto-resize -buffer-name=line line<CR>
			nnoremap <silent> [unite]b :<C-u>Unite -auto-resize -buffer-name=buffers buffer file_mru<CR>
			nnoremap <silent> [unite]/ :<C-u>UniteWithCursorWord -no-quit -buffer-name=search grep:.<CR>
			nnoremap <silent> [unite]m :<C-u>Unite -auto-resize -buffer-name=mappings mapping<CR>
			nnoremap <silent> [unite]s :<C-u>Unite -quick-match buffer<CR>
		"}}}
		NeoBundleLazy 'Shougo/neomru.vim', {'autoload':{'unite_sources':'file_mru'}}
		NeoBundleLazy 'osyo-manga/unite-airline_themes', {'autoload':{'unite_sources':'airline_themes'}} "{{{
			nnoremap <silent> [unite]a :<C-u>Unite -winheight=10 -auto-preview -buffer-name=airline_themes airline_themes<CR>
		"}}}
		NeoBundleLazy 'ujihisa/unite-colorscheme', {'autoload':{'unite_sources':'colorscheme'}} "{{{
			nnoremap <silent> [unite]c :<C-u>Unite -winheight=10 -auto-preview -buffer-name=colorschemes colorscheme<CR>
		"}}}
		NeoBundleLazy 'tsukkee/unite-tag', {'autoload':{'unite_sources':['tag','tag/file']}} "{{{
			nnoremap <silent> [unite]t :<C-u>Unite -auto-resize -buffer-name=tag tag tag/file<CR>
		"}}}
		NeoBundleLazy 'Shougo/unite-outline', {'autoload':{'unite_sources':'outline'}} "{{{
			nnoremap <silent> [unite]o :<C-u>Unite -auto-resize -buffer-name=outline outline<CR>
		"}}}
		NeoBundleLazy 'Shougo/unite-help', {'autoload':{'unite_sources':'help'}} "{{{
			nnoremap <silent> [unite]h :<C-u>Unite -auto-resize -buffer-name=help help<CR>
		"}}}
		NeoBundleLazy 'Shougo/junkfile.vim', {'autoload':{'commands':'JunkfileOpen','unite_sources':['junkfile','junkfile/new']}} "{{{
			let g:junkfile#directory=s:get_cache_dir('junk')
			nnoremap <silent> [unite]j :<C-u>Unite -auto-resize -buffer-name=junk junkfile junkfile/new<CR>
		"}}}
	endif "}}}
	if count(s:settings.plugin_groups, 'indents') "{{{
		NeoBundle 'nathanaelkane/vim-indent-guides' "{{{
			let g:indent_guides_start_level=1
			let g:indent_guides_guide_size=1
			let g:indent_guides_enable_on_vim_startup=0
			let g:indent_guides_color_change_percent=3
			if !has('gui_running')
				let g:indent_guides_auto_colors=0
				function! s:indent_set_console_colors()
					hi IndentGuidesOdd ctermbg=235
					hi IndentGuidesEven ctermbg=236
				endfunction
				autocmd VimEnter,Colorscheme * call s:indent_set_console_colors()
			endif
		"}}}
	endif "}}}
	if count(s:settings.plugin_groups, 'textobj') "{{{
		NeoBundle 'kana/vim-textobj-user'
		NeoBundle 'kana/vim-textobj-indent'
		NeoBundle 'kana/vim-textobj-entire'
		NeoBundle 'lucapette/vim-textobj-underscore'
	endif "}}}
	if count(s:settings.plugin_groups, 'misc') "{{{
		NeoBundle 'xolox/vim-misc'
		NeoBundle 'xolox/vim-session'
		NeoBundleLazy 'mbbill/fencview', {'autoload':{'commands':['FencView','FencAutoDetect']}}
		if exists('$TMUX')
			NeoBundle 'christoomey/vim-tmux-navigator'
		endif
		NeoBundle 'kana/vim-vspec'
		NeoBundleLazy 'tpope/vim-scriptease', {'autoload':{'filetypes':['vim']}}
		NeoBundleLazy 'jtratner/vim-flavored-markdown', {'autoload':{'filetypes':['markdown','ghmarkdown']}}
		if executable('redcarpet') && executable('instant-markdown-d')
			NeoBundleLazy 'suan/vim-instant-markdown', {'autoload':{'filetypes':['markdown','ghmarkdown']}}
		endif
		NeoBundleLazy 'guns/xterm-color-table.vim', {'autoload':{'commands':'XtermColorTable'}}
		NeoBundle 'chrisbra/vim_faq'
		NeoBundle 'vimwiki'
		NeoBundle 'bufkill.vim'
		NeoBundle 'mhinz/vim-startify' "{{{
			let g:startify_session_dir = s:get_cache_dir('sessions')
			let g:startify_change_to_vcs_root = 1
			let g:startify_show_sessions = 1
		"}}}
		NeoBundle 'scrooloose/syntastic' "{{{
			" run `:SyntasticCheck` to check syntax
		"}}}
		NeoBundleLazy 'mattn/gist-vim', {'depends':'mattn/webapi-vim','autoload':{'commands':'Gist'}} "{{{
			let g:gist_post_private=1
			let g:gist_show_privates=1
		"}}}
		NeoBundleLazy 'Shougo/vimshell.vim', {'autoload':{'commands':['VimShell','VimShellInteractive']}} "{{{
			if s:is_macvim
				let g:vimshell_editor_command='mvim'
			else
				let g:vimshell_editor_command='vim'
			endif
			let g:vimshell_right_prompt='getcwd()'
			let g:vimshell_data_directory=s:get_cache_dir('vimshell')
			let g:vimshell_vimshrc_path='~/.vim/vimshrc'

			"nnoremap <Leader>c :VimShell -split<CR>
			"nnoremap <Leader>cc :VimShell -split<CR>
			"nnoremap <Leader>cn :VimShellInteractive node<CR>
			"nnoremap <Leader>cl :VimShellInteractive lua<CR>
			"nnoremap <Leader>CR :VimShellInteractive irb<CR>
			"nnoremap <Leader>cp :VimShellInteractive python<CR>
		"}}}
		NeoBundleLazy 'zhaocai/GoldenView.Vim', {'autoload':{'mappings':['<Plug>ToggleGoldenViewAutoResize']}} "{{{
			let g:goldenview__enable_default_mapping=0
			nmap <silent> <Leader>z <Plug>ToggleGoldenViewAutoResize
		"}}}
		" do not use conque-shell together with conque-gdb
		"NeoBundle 'oplatek/Conque-Shell' "{{{
		"}}}
		NeoBundleLazy 'vim-scripts/Conque-GDB', {'autoload':{'commands':['ConqueGdb','ConqueGdbTab','ConqueGdbVSplit','ConqueGdbSplit','ConqueTerm','ConqueTermTab','ConqueTermVSplit','ConqueTermSplit']}} "{{{
			let g:ConqueGdb_Leader = '\'
			"let g:ConqueGdb_GdbExe = '~/local/bin/gdb'
			nnoremap <Leader>d :ConqueGdbVSplit<CR>
		"}}}
	endif "}}}
	if count(s:settings.plugin_groups, 'windows') "{{{
		NeoBundleLazy 'PProvost/vim-ps1', {'autoload':{'filetypes':['ps1']}} "{{{
			autocmd BufNewFile,BufRead *.ps1,*.psd1,*.psm1 setlocal ft=ps1
		"}}}
		NeoBundleLazy 'nosami/Omnisharp', {'autoload':{'filetypes':['cs']}}
	endif "}}}

	nnoremap <Leader>nbu :Unite neobundle/update -vertical -no-start-insert<CR>
"}}}

" mappings {{{
	" formatting shortcuts
	nmap <Leader>fef :call Preserve("normal gg=G")<CR>
	nmap <Leader>f$ :call StripTrailingWhitespace()<CR>
	vmap <Leader>s :sort<CR>

	" eval vimscript by line or visual selection
	nmap <silent> <Leader>e :call Source(line('.'), line('.'))<CR>
	vmap <silent> <Leader>e :call Source(line('v'), line('.'))<CR>

	nnoremap <Leader>w :w<CR>

	" remap arrow keys
	nnoremap <Left> :bprev<CR>
	nnoremap <Right> :bnext<CR>
	"nnoremap <Up> :tabnext<CR>
	"nnoremap <Down> :tabprev<CR>

	" smash escape
	inoremap jk <Esc>
	inoremap kj <Esc>

	" change cursor position in insert mode
	" use S-BS instead of BS to delete in insert mode in some terminal
	inoremap <C-h> <Left>
	inoremap <C-l> <Right>

	inoremap <C-u> <C-g>u<C-u>

	if mapcheck('<Space>/') == ''
		nnoremap <Space>/ :vimgrep //gj **/*<Left><Left><Left><Left><Left><Left><Left><Left>
	endif

	" sane regex {{{
		nnoremap / /\v
		vnoremap / /\v
		nnoremap ? ?\v
		vnoremap ? ?\v
		nnoremap :s/ :s/\v
	" }}}

	" command-line window {{{
		nnoremap q: q:i
		nnoremap q/ q/i
		nnoremap q? q?i
	" }}}

	" folds {{{
		nnoremap zr zr:echo &foldlevel<CR>
		nnoremap zm zm:echo &foldlevel<CR>
		nnoremap zR zR:echo &foldlevel<CR>
		nnoremap zM zM:echo &foldlevel<CR>
	" }}}

	" screen line scroll
	nnoremap <silent> j gj
	nnoremap <silent> k gk

	" auto center {{{
		nnoremap <silent> n nzz
		nnoremap <silent> N Nzz
		nnoremap <silent> * *zz
		nnoremap <silent> # #zz
		nnoremap <silent> g* g*zz
		nnoremap <silent> g# g#zz
		nnoremap <silent> <C-o> <C-o>zz
		nnoremap <silent> <C-i> <C-i>zz
	"}}}

	" reselect visual block after indent
	vnoremap < <gv
	vnoremap > >gv

	" reselect last paste
	nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

	" find current word in quickfix
	"nnoremap <Leader>fw :execute "vimgrep ".expand("<cword>")." %"<CR>:copen<CR>
	" find last search in quickfix
	"nnoremap <Leader>ff :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

	" shortcuts for windows {{{
		" <http://stackoverflow.com/questions/9092982/mapping-c-j-to-something-in-vim>
		let g:C_Ctrl_j = 'off'
		let g:BASH_Ctrl_j = 'off'
		nnoremap <Leader>v <C-w>v<C-w>l
		nnoremap <Leader>s <C-w>s
		nnoremap <Leader>vsa :vert sba<CR>
		nnoremap <C-h> <C-w>h
		nnoremap <C-j> <C-w>j
		nnoremap <C-k> <C-w>k
		nnoremap <C-l> <C-w>l
	"}}}

	" tab shortcuts
	map <Leader>tn :tabnew<CR>
	map <Leader>tc :tabclose<CR>

	" make Y consistent with C and D. See :help Y.
	nnoremap Y y$

	" hide annoying quit message
	nnoremap <C-c> <C-c>:echo<CR>

	" window killer
	nnoremap <silent> Q :call CloseWindowOrKillBuffer()<CR>

	if neobundle#is_sourced('vim-dispatch')
		nnoremap <Leader>tag :Dispatch ctags -R<CR>
	endif

	" helpers for profiling {{{
		nnoremap <silent> <Leader>DD :exe ":profile start profile.log"<CR>:exe ":profile func *"<CR>:exe ":profile file *"<CR>
		nnoremap <silent> <Leader>DP :exe ":profile pause"<CR>
		nnoremap <silent> <Leader>DC :exe ":profile continue"<CR>
		nnoremap <silent> <Leader>DQ :exe ":profile pause"<CR>:noautocmd qall!<CR>
	"}}}
"}}}

" commands {{{
	command! -bang Q q<bang>
	command! -bang QA qa<bang>
	command! -bang Qa qa<bang>
"}}}

" autocmd {{{
	" go back to previous position of cursor if any
	autocmd BufReadPost *
		\ if line("'\"") > 0 && line("'\"") <= line("$") |
		\  exe 'normal! g`"zvzz' |
		\ endif

	autocmd FileType js,scss,css autocmd BufWritePre <buffer> call StripTrailingWhitespace()
	autocmd FileType css,scss setlocal foldmethod=marker foldmarker={,}
	autocmd FileType css,scss nnoremap <silent> <Leader>S vi{:sort<CR>
	autocmd FileType python autocmd BufWritePre <buffer> call StripTrailingWhitespace()
	autocmd FileType python setlocal foldmethod=indent
	autocmd FileType php autocmd BufWritePre <buffer> call StripTrailingWhitespace()
	autocmd FileType coffee autocmd BufWritePre <buffer> call StripTrailingWhitespace()
	autocmd FileType vim setlocal foldmethod=indent keywordprg=:help

	" quickfix window always on the bottom taking the whole horizontal space
	autocmd FileType qf wincmd J
"}}}

" color schemes {{{
	NeoBundle 'taohex/vim-colors-solarized' "{{{
		let g:solarized_termcolors=256
		let g:solarized_termtrans=1
	"}}}
	NeoBundle 'nanotech/jellybeans.vim'
	NeoBundle 'tomasr/molokai'
	NeoBundle 'chriskempson/vim-tomorrow-theme'
	NeoBundle 'chriskempson/base16-vim'
	NeoBundle 'w0ng/vim-hybrid'
	NeoBundle 'sjl/badwolf'
	NeoBundle 'zeis/vim-kolor' "{{{
		let g:kolor_underlined=1
	"}}}
"}}}

" finish loading {{{
	if exists('g:dotvim_settings.disabled_plugins')
		for plugin in g:dotvim_settings.disabled_plugins
			execute 'NeoBundleDisable '.plugin
		endfor
	endif

	call neobundle#end()
	filetype plugin indent on
	syntax enable
	execute 'colorscheme '.s:settings.colorscheme

	NeoBundleCheck
"}}}


" vim: fdm=marker ts=4 sts=4 sw=4 fdl=0
