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

	" vimfiler
	"if !empty(glob("vimfiler"))
	let g:vimfiler_tree_leaf_icon = ' '
	let g:vimfiler_tree_opened_icon = 'v'
	let g:vimfiler_tree_closed_icon = '>'
	let g:vimfiler_file_icon = '-'
	let g:vimfiler_marked_file_icon = '*'
	"endif

	" syntastic
	let g:syntastic_error_symbol = '*'
	let g:syntastic_style_error_symbol = '*'
	let g:syntastic_warning_symbol = '*'
	let g:syntastic_style_warning_symbol = '*'

	" signify
	let g:signify_sign_add               = '+'
	let g:signify_sign_delete            = '_'
	let g:signify_sign_delete_first_line = '_'
	let g:signify_sign_change            = '!'
	let g:signify_sign_changedelete      = g:signify_sign_change

" }}}


" vim:foldmethod=marker:foldlevel=0
