" Encoding "{{{
" ---------------------------------------------------------------------
" Encoding settings

	" <http://vimdoc.sourceforge.net/htmldoc/mbyte.html>
	set encoding=gbk
	set fileencoding=gbk
	set fileencodings=ucs-bom,utf-8,gb2312,gbk,gb18030,big5,latin1
	set fileformats=unix,mac,dos
	set termencoding=gbk

	" characters for displaying in list mode
	set listchars=extends:>,precedes:<,tab:>\ ,trail:~

	set showbreak&

	if has('conceal')
		set conceallevel=1
		set listchars+=conceal:-
	endif

	" airline
	"if !empty(glob("vim-airline"))
	let g:airline_left_sep = '>'
	let g:airline_right_sep = '<'
	"endif

	" lightline
	let g:lightline_buffer_active_buffer_left = ''
	let g:lightline_buffer_active_buffer_right = ''
	let g:lightline_buffer_separator = ' '	" ' | '
	let g:lightline_buffer_modified = ' *'
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
	let g:lightline_buffer_logo = ''
	let g:lightline_buffer_readonly_icon = 'RO'
	let g:lightline_buffer_modified_icon = '*'
	let g:lightline_buffer_git_icon = ''
	let g:lightline_buffer_ellipsis_icon = '..'
	let g:lightline_buffer_expand_left_icon = '< '
	let g:lightline_buffer_expand_right_icon = ' >'

	" :help tabline
	" tabline use "%1T" for the first label, "%2T" for the second one, etc. use "%T" for ending. use "%X" items for closing labels
	" use %X after the label, e.g. %3Xclose%X. use %999X for a "close current tab"
	" mouse left-click between "%1T" and "%2T" go to tab 1, between "%2T" and "%3T" go to tab 2, etc.
	" mouse double-click anywhere new a tab
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
			\ 'lineinfo': '%3p%% %3l:%-2v',
			\ 'readonly': '%{&readonly?"RO":""}',
			\ 'modified': '%{&filetype=="help"?"":&modified?"*":&modifiable?"":"-"}',
			\ 'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}',
		\ },
		\ 'component_visible_condition': {
			\ 'readonly': '(&filetype!="help"&& &readonly)',
			\ 'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
			\ 'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())',
		\ },
		\ 'separator': { 'left': '>', 'right': '<' },
		\ 'subseparator': { 'left': '>', 'right': '<' },
		\ 'tabline_separator': { 'left': ">", 'right': "<" },
		\ 'tabline_subseparator': { 'left': ">", 'right': "<" },
	\ }
			"\ 'left': [ [ 'bufferline' ] ],
			"\ 'right': [ [ 'close' ] ],

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

	" nerdtree
	let g:NERDTreeDirArrows = 1
	let g:NERDTreeDirArrowExpandable = '>'
	let g:NERDTreeDirArrowCollapsible = 'v'

	" nerdtree-git-plugin
	"if !empty(glob("nerdtree-git-plugin"))
	let g:NERDTreeIndicatorMapCustom = {
		\ 'Modified'  : '~',
		\ 'Staged'    : '+',
		\ 'Untracked' : '*',
		\ 'Renamed'   : '>',
		\ 'Unmerged'  : '=',
		\ 'Deleted'   : '-',
		\ 'Dirty'     : 'x',
		\ 'Clean'     : 'v',
		\ 'Unknown'   : '?'
	\ }
	"endif

	" vimfiler
	"if !empty(glob("vimfiler"))
	let g:vimfiler_tree_leaf_icon = ' '
	let g:vimfiler_tree_opened_icon = 'v'
	let g:vimfiler_tree_closed_icon = '>'
	let g:vimfiler_file_icon = ' '
	let g:vimfiler_marked_file_icon = '*'
	"endif

	" syntastic
	let g:syntastic_error_symbol = 'x'
	let g:syntastic_style_error_symbol = '*'
	let g:syntastic_warning_symbol = '!'
	let g:syntastic_style_warning_symbol = '~'

	" signify
	let g:signify_sign_add               = '+'
	let g:signify_sign_delete            = '_'
	let g:signify_sign_delete_first_line = '_'
	let g:signify_sign_change            = '!'
	let g:signify_sign_changedelete      = g:signify_sign_change

" }}}


" vim:foldmethod=marker:foldlevel=0
