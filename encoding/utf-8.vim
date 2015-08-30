" Encoding "{{{
" ---------------------------------------------------------------------
" Encoding settings

	let s:powerline_fonts = 1

	" <http://vimdoc.sourceforge.net/htmldoc/mbyte.html>
	set encoding=utf-8
	set fileencoding=utf-8
	set fileencodings=ucs-bom,utf-8,gb2312,gbk,gb18030,big5,latin1
	set fileformats=unix,mac,dos
	set termencoding=utf-8

	" characters for displaying in list mode
	if &termencoding ==# 'utf-8' || &encoding ==# 'utf-8'
		if s:powerline_fonts == 1
			set listchars=extends:>,precedes:<,tab:▶\ ,trail:•
		else
			set listchars=extends:>,precedes:<,tab:►\ ,trail:•
		endif
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
	if s:powerline_fonts == 1
		let g:airline_left_sep = ''
		let g:airline_right_sep = ''
	else
		let g:airline_left_sep = '►'
		let g:airline_right_sep = '◄'
	endif
	"endif

	" vimfiler
	"if !empty(glob("vimfiler"))
	let g:vimfiler_tree_leaf_icon = ' '
	let g:vimfiler_tree_opened_icon = '▾'
	let g:vimfiler_tree_closed_icon = '▸'
	let g:vimfiler_file_icon = '-'
	let g:vimfiler_marked_file_icon = '★'
	"endif

	" lightline
	"if !empty(glob("lightline.vim"))
		" <https://github.com/itchyny/lightline.vim/issues/36>
		let g:lightline = {
				\ 'colorscheme': 'solarized',
				\ 'active': {
					\ 'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
				\ },
				\ 'tabline': {
					\ 'left': [ [ 'bufferline' ] ],
					\ 'right': [ [ 'close' ] ] },
				\ 'component_function': {
					\ 'bufferline': 'LightLineBufferline'
				\ },
				\ 'component': {
					\ 'readonly': '%{&readonly?"":""}',
					\ 'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
					\ 'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
				\ },
				\ 'component_visible_condition': {
					\ 'readonly': '(&filetype!="help"&& &readonly)',
					\ 'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
					\ 'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
				\ },
				\ 'separator': { 'left': '', 'right': '' },
				\ 'subseparator': { 'left': '', 'right': '' }
		\ }
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
