" Encoding "{{{
" ---------------------------------------------------------------------
" Encoding settings

	" <http://vimdoc.sourceforge.net/htmldoc/mbyte.html>
	set encoding=utf-8
	set fileencoding=utf-8
	set fileencodings=ucs-bom,utf-8,gb2312,gbk,gb18030,big5,latin1
	set fileformats=unix,mac,dos
	set termencoding=utf-8

	" characters for displaying in list mode
	if &termencoding ==# 'utf-8' || &encoding ==# 'utf-8'
		"if g:nvim_settings.powerline_fonts == 1
			set listchars=extends:>,precedes:<,tab:▶\ ,trail:•
		"else
		"	set listchars=extends:>,precedes:<,tab:►\ ,trail:•
		"endif
	else
		set listchars=extends:>,precedes:<,tab:>\ ,trail:~
	endif
	"set listchars=tab:│\ ,trail:•,extends:❯,precedes:❮

	"set showbreak=▲\ 
	set showbreak&
	"let &showbreak='↪ '

	if has('conceal')
		set conceallevel=1
		set listchars+=conceal:Δ
	endif

	" airline
	"if !empty(glob("vim-airline"))
	if g:nvim_settings.powerline_fonts == 1
		let g:airline_left_sep = ''
		let g:airline_right_sep = ''
	else
		let g:airline_left_sep = '▶'
		let g:airline_right_sep = '◀'
	endif
	"endif

	" lightline
	"if !empty(glob("lightline.vim"))
	" <https://github.com/itchyny/lightline.vim/issues/36>

	let g:lightline_buffer_active_buffer_left = ''
	" '⫸ '
	let g:lightline_buffer_active_buffer_right = ''
	let g:lightline_buffer_separator = ' '
	" ' ¦ '
	"
	let g:lightline_buffer_modified = ' ✭'
	let g:lightline_buffer_show_bufnr = 1
	" :help filename-modifiers
	let g:lightline_buffer_fname_mod = ':t'	" ':.'
	let g:lightline_buffer_rotate = 0
	let g:lightline_buffer_excludes = ['\[vimfiler\]']
	let g:lightline_buffer_status_info = {
		\ 'count': 0,
		\ 'before': '',
		\ 'current': '',
		\ 'after': '',
	\ }
	let g:lightline_buffer_maxflen = 30
	let g:lightline_buffer_maxfextlen = 3
	let g:lightline_buffer_minflen = 16
	let g:lightline_buffer_minfextlen = 3
	let g:lightline_buffer_reservelen = 20
	" os x: 
	" ubuntu: 
	let g:lightline_buffer_logo = ' '
	let g:lightline_buffer_readonly_icon = ''
	let g:lightline_buffer_modified_icon = '✭'
	let g:lightline_buffer_git_icon = ' '
	let g:lightline_buffer_ellipsis_icon = '..'	" '…'
	let g:lightline_buffer_expand_left_icon = '◀ '	" '… '
	let g:lightline_buffer_expand_right_icon = ' ▶'	" ' …'

	" :help tabline
	" tabline use "%1T" for the first label, "%2T" for the second one, etc. use "%T" for ending. use "%X" items for closing labels
	" use %X after the label, e.g. %3Xclose%X. use %999X for a "close current tab"
	" mouse left-click between "%1T" and "%2T" go to tab 1, between "%2T" and "%3T" go to tab 2, etc.
	" mouse double-click anywhere new a tab
	if g:nvim_settings.powerline_fonts == 1
		let g:lightline = {
			\ 'colorscheme': 'lightline_solarized',
			\ 'active': {
				\ 'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], [ 'buffertag' ], ],
				\ 'right': [ [ 'lineinfo', 'syntastic' ], [ 'fileinfo' ], [ 'filetype' ], ],
			\ },
			\ 'inactive': {
				\ 'left': [ [ 'filename' ], ],
				\ 'right': [ [ 'lineinfo' ], ],
			\ },
			\ 'tabline': {
				\ 'left': [ [ 'bufferinfo' ], [ 'bufferbefore', 'buffercurrent', 'bufferafter' ], ],
				\ 'right': [ [ 'close' ], ],
			\ },
			\ 'component_expand': {
				\ 'buffercurrent': 'lightline#buffer#buffercurrent2',
				\ 'bufferall': 'lightline#buffer#bufferall',
				\ 'syntastic': 'lightline#buffer#syntastic',
			\ },
			\ 'component_type': {
				\ 'buffercurrent': 'tabsel',
				\ 'bufferall': 'tabsel',
			\ },
			\ 'component_function': {
				\ 'bufferbefore': 'lightline#buffer#bufferbefore',
				\ 'bufferafter': 'lightline#buffer#bufferafter',
				\ 'bufferinfo': 'lightline#buffer#bufferinfo',
				\ 'buffertag': 'LightlineTag',
				\ 'fugitive': 'LightlineFugitive',
				\ 'fileinfo': 'LightlineFileinfo',
				\ 'filename': 'LightlineFilename',
				\ 'fileformat': 'LightlineFileformat',
				\ 'filetype': 'LightlineFiletype',
				\ 'fileencoding': 'LightlineFileencoding',
				\ 'mode': 'LightlineMode',
			\ },
			\ 'component': {
				\ 'lineinfo': '%3p%% %3l:%-2v',
				\ 'readonly': '%{&readonly?"":""}',
				\ 'modified': '%{&filetype=="help"?"":&modified?"✭":&modifiable?"":"-"}',
				\ 'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}',
			\ },
			\ 'component_visible_condition': {
				\ 'readonly': '(&filetype!="help"&& &readonly)',
				\ 'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
				\ 'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())',
			\ },
			\ 'separator': { 'left': '', 'right': '' },
			\ 'subseparator': { 'left': '', 'right': '' },
			\ 'tabline_separator': { 'left': "", 'right': "" },
			\ 'tabline_subseparator': { 'left': "", 'right': "" },
		\ }
				"\ 'left': [ [ 'bufferline' ] ],
				"\ 'right': [ [ 'close' ] ],
	else
		let g:lightline = {
			\ 'colorscheme': 'lightline_solarized',
			\ 'active': {
				\ 'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], [ 'buffertag' ], ],
				\ 'right': [ [ 'lineinfo', 'syntastic' ], [ 'fileinfo' ], [ 'filetype' ], ],
			\ },
			\ 'inactive': {
				\ 'left': [ [ 'filename' ], ],
				\ 'right': [ [ 'lineinfo' ], ],
			\ },
			\ 'tabline': {
				\ 'left': [ [ 'bufferinfo' ], [ 'bufferbefore', 'buffercurrent', 'bufferafter' ], ],
				\ 'right': [ [ 'close' ], ],
			\ },
			\ 'component_expand': {
				\ 'buffercurrent': 'lightline#buffer#buffercurrent2',
				\ 'bufferall': 'lightline#buffer#bufferall',
				\ 'syntastic': 'lightline#buffer#syntastic',
			\ },
			\ 'component_type': {
				\ 'buffercurrent': 'tabsel',
				\ 'bufferall': 'tabsel',
			\ },
			\ 'component_function': {
				\ 'bufferbefore': 'lightline#buffer#bufferbefore',
				\ 'bufferafter': 'lightline#buffer#bufferafter',
				\ 'bufferinfo': 'lightline#buffer#bufferinfo',
				\ 'buffertag': 'LightlineTag',
				\ 'fugitive': 'LightlineFugitive',
				\ 'fileinfo': 'LightlineFileinfo',
				\ 'filename': 'LightlineFilename',
				\ 'fileformat': 'LightlineFileformat',
				\ 'filetype': 'LightlineFiletype',
				\ 'fileencoding': 'LightlineFileencoding',
				\ 'mode': 'LightlineMode',
			\ },
			\ 'component': {
				\ 'lineinfo': '%3p%% %3l:%-2v',
				\ 'readonly': '%{&readonly?"":""}',
				\ 'modified': '%{&filetype=="help"?"":&modified?"✭":&modifiable?"":"-"}',
				\ 'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}',
			\ },
			\ 'component_visible_condition': {
				\ 'readonly': '(&filetype!="help"&& &readonly)',
				\ 'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
				\ 'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())',
			\ },
			\ 'separator': { 'left': '▶', 'right': '◀' },
			\ 'subseparator': { 'left': '>', 'right': '<' },
			\ 'tabline_separator': { 'left': "▶", 'right': "◀" },
			\ 'tabline_subseparator': { 'left': ">", 'right': "<" },
		\ }
				"\ 'left': [ [ 'bufferline' ] ],
				"\ 'right': [ [ 'close' ] ],
	endif

	"let g:lightline.enable = {
	"	\ 'statusline': 1,
	"	\ 'tabline': 1,
	"\ }

	let g:lightline.mode_map = {
		\ 'n' : 'N',
		\ 'i' : 'I',
		\ 'R' : 'R',
		\ 'v' : 'V',
		\ 'V' : 'V',
		\ 'c' : 'C',
		\ "\<C-v>": 'V',
		\ 's' : 'S',
		\ 'S' : 'S',
		\ "\<C-s>": 'S',
		\ '?': ' ',
	\ }

	"endif

	" nerdtree
	let g:NERDTreeDirArrows = 1
	let g:NERDTreeDirArrowExpandable = '▸'
	let g:NERDTreeDirArrowCollapsible = '▾'

	" nerdtree-git-plugin
	"if !empty(glob("nerdtree-git-plugin"))
	let g:NERDTreeIndicatorMapCustom = {
		\ 'Modified'  : '✹',
		\ 'Staged'    : '✚',
		\ 'Untracked' : '✭',
		\ 'Renamed'   : '➜',
		\ 'Unmerged'  : '═',
		\ 'Deleted'   : '✖',
		\ 'Dirty'     : '✗',
		\ 'Clean'     : '✔︎',
		\ 'Unknown'   : '?'
	\ }
	"endif

	" vimfiler
	"if !empty(glob("vimfiler"))
	let g:vimfiler_tree_leaf_icon = ' '
	let g:vimfiler_tree_opened_icon = '▾'
	let g:vimfiler_tree_closed_icon = '▸'
	let g:vimfiler_file_icon = ' '
	let g:vimfiler_marked_file_icon = '★'
	"endif

	" syntastic
	let g:syntastic_error_symbol = '✗'
	let g:syntastic_style_error_symbol = '✠'
	let g:syntastic_warning_symbol = '∆'
	let g:syntastic_style_warning_symbol = '≈'

	" signify
	let g:signify_sign_add               = '+'
	let g:signify_sign_delete            = '_'
	let g:signify_sign_delete_first_line = '‾'
	let g:signify_sign_change            = '!'
	let g:signify_sign_changedelete      = g:signify_sign_change

" }}}


" vim:foldmethod=marker:foldlevel=0
