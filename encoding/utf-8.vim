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
		set listchars=extends:>,precedes:<,tab:▸\ ,trail:~
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
	if s:powerline_fonts == 1
		let g:airline_left_sep = ''
		let g:airline_right_sep = ''
	else
		let g:airline_left_sep = '►'
		let g:airline_right_sep = '◄'
	endif

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
