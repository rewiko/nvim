" General "{{{
" ---------------------------------------------------------------------
" General settings

	if (v:version < 700)
		finish
	endif

	let g:dotvim_settings = {}
	let g:dotvim_settings.version = 1

	let g:dotvim_settings.plugin_groups = []
	call add(g:dotvim_settings.plugin_groups, 'core')
	call add(g:dotvim_settings.plugin_groups, 'language')
	call add(g:dotvim_settings.plugin_groups, 'c')
	call add(g:dotvim_settings.plugin_groups, 'scm')
	call add(g:dotvim_settings.plugin_groups, 'indents')
	call add(g:dotvim_settings.plugin_groups, 'navigation')
	call add(g:dotvim_settings.plugin_groups, 'unite')
	call add(g:dotvim_settings.plugin_groups, 'autocomplete')
	call add(g:dotvim_settings.plugin_groups, 'misc')

	let s:encoding = "utf-8"
	let s:use_local_bin = 0
	"let s:theme = "molokai"
	let s:theme = "solarized"
	let s:force256 = 0
	let s:termtrans = 0
	"let s:cscopeprg="gtags-cscope"
	let s:cscopeprg="cscope"

	source ~/.vim/vimrc

	if s:encoding == "utf-8"
		source ~/.vim/encoding/utf-8.vim
	elseif s:encoding == "gbk"
		source ~/.vim/encoding/gbk.vim
	else
		source ~/.vim/encoding/latin1.vim
	endif

" }}}

" User interface "{{{
" ---------------------------------------------------------------------
" User interface settings

	set wildmode=full

	" color
	set t_Co=256
	try
		" run `:syntax` to view highlight
		if s:theme == "molokai"
			let g:molokai_original = 1
			colorscheme molokai
			set background=dark
			highlight NonText ctermfg=235 guifg=#262626
			highlight SpecialKey ctermfg=235 guifg=#262626
			"highlight PmenuSel ctermfg=231 guifg=#FFFFFF
			highlight CTagsClass ctermfg=81 guifg=#66D9EF
		elseif s:theme == "solarized"
			" 16 color palette is recommended
			" <https://github.com/altercation/vim-colors-solarized>
			if s:force256 == 1
				let g:solarized_termcolors = 256
			else
				let g:solarized_termcolors = 16
			endif
			let g:solarized_termtrans = s:termtrans
			let g:solarized_degrade = 0
			set background=dark
			" <https://github.com/seanbell/term-tools/issues/2>
			" run `:help signify` to view signify highlight
			" run `:help highlight-groups` to view vim highlight
			colorscheme solarized
			if s:force256 == 1
				highlight NonText ctermfg=236 ctermbg=none
				highlight SpecialKey ctermfg=236 ctermbg=none
				highlight LineNr ctermfg=240 ctermbg=0
				highlight CursorLine ctermbg=0
				"highlight CursorLineNr
				highlight CTagsClass ctermfg=125
			else
				exe "highlight! CTagsClass" . g:solarized_vars['fmt_none'] . g:solarized_vars['fg_magenta'] . g:solarized_vars['bg_none']

				" highlight lines in signify and vimdiff etc.
				"exe "highlight! DiffAdd" . g:solarized_vars['fmt_none'] . g:solarized_vars['fg_green'] . g:solarized_vars['bg_base02']
				"exe "highlight! DiffDelete" . g:solarized_vars['fmt_none'] . g:solarized_vars['fg_red']  . g:solarized_vars['bg_base02']
				"exe "highlight! DiffChange" . g:solarized_vars['fmt_none'] . g:solarized_vars['fg_yellow'] . g:solarized_vars['bg_base02']

				" highlight signs in signify
				"exe "highlight! SignifySignAdd" . g:solarized_vars['fmt_none'] . g:solarized_vars['fg_green'] . g:solarized_vars['bg_base02']
				"exe "highlight! SignifySignDelete" . g:solarized_vars['fmt_none'] . g:solarized_vars['fg_red'] . g:solarized_vars['bg_base02']
				"exe "highlight! SignifySignChange" . g:solarized_vars['fmt_none'] . g:solarized_vars['fg_yellow'] . g:solarized_vars['bg_base02']

				" indent guides
				exe "autocmd VimEnter,Colorscheme * :highlight! IndentGuidesOdd" . g:solarized_vars['fmt_none'] . g:solarized_vars['fg_base03'] . g:solarized_vars['bg_cyan']
				exe "autocmd VimEnter,Colorscheme * :highlight! IndentGuidesEven" . g:solarized_vars['fmt_none'] . g:solarized_vars['fg_base03'] . g:solarized_vars['bg_base02']
			endif
		endif
	catch
		set background=dark
		colorscheme default
	endtry

	" minimum number of lines to scroll
	set scrolljump=1
	" minimum number of lines above and below cursor
	set scrolloff=10
	" minimum number of columns to left and right of cursor
	set sidescrolloff=5

	" mouse
	"set mouse&
	set mouse=a
	set ttymouse=xterm2

	" don't use spaces instead of tabs
	set noexpandtab
	" number of spaces per tab for display
	set tabstop=4
	" number of spaces per tab in insert mode
	set softtabstop=4
	" number of spaces when indenting
	set shiftwidth=4

"}}}

" Program "{{{
" ---------------------------------------------------------------------
" Program settings

	" cscopeprg
	if s:use_local_bin != 0
		if s:cscopeprg == "gtags-cscope"
			set cscopeprg=~/local/bin/gtags-cscope
		elseif s:cscopeprg == "cscope"
			set cscopeprg=~/local/bin/cscope
		endif
	else
		if s:cscopeprg == "gtags-cscope"
			set cscopeprg=gtags-cscope
		elseif s:cscopeprg == "cscope"
			set cscopeprg=cscope
		endif
	endif

	if s:cscopeprg == "gtags-cscope"
		" global
		" locate symbols which are not defined in `GTAGS'
		nnoremap <C-]>s :Gtags -s <C-R>=expand("<cword>")<CR><CR>
		"nnoremap <C-\>s :tab split<CR>:execute "Gtags -s " . expand("<cword>")<CR>
		" locate strings
		nnoremap <C-]>g :Gtags -g <C-R>=expand("<cword>")<CR><CR>
		"nnoremap <C-\>g :tab split<CR>:execute "Gtags -g " . expand("<cword>")<CR>
		" find reference
		nnoremap <C-]>r :Gtags -r <C-R>=expand("<cword>")<CR><CR>
		"nnoremap <C-\>r :tab split<CR>:execute "Gtags -r " . expand("<cword>")<CR>
	elseif s:cscopeprg == "cscope"
		" cscope
		if has("cscope")
			nmap ; [cscope]
			nnoremap [cscope] <nop>
			" 's' symbol: find all references to the token under cursor
			nnoremap [cscope]s :cs find s <C-R>=expand("<cword>")<CR><CR>
			"nnoremap <C-\>s :tab split<CR>:execute "cs find s " . expand("<cword>")<CR>
			" 'g' global: find global definition(s) of the token under cursor
			nnoremap [cscope]g :cs find g <C-R>=expand("<cword>")<CR><CR>
			"nnoremap <C-\>g :tab split<CR>:execute "cs find g " . expand("<cword>")<CR>
			" 'c' calls:  find all calls to the function name under cursor
			nnoremap [cscope]c :cs find c <C-R>=expand("<cword>")<CR><CR>
			"nnoremap <C-\>c :tab split<CR>:execute "cs find c " . expand("<cword>")<CR>
			" 't' text:   find all instances of the text under cursor
			nnoremap [cscope]t :cs find t <C-R>=expand("<cword>")<CR><CR>
			"nnoremap <C-\>t :tab split<CR>:execute "cs find t " . expand("<cword>")<CR>
			" 'e' egrep:  egrep search for the word under cursor
			nnoremap [cscope]e :cs find e <C-R>=expand("<cword>")<CR><CR>
			"nnoremap <C-\>e :tab split<CR>:execute "cs find e " . expand("<cword>")<CR>
			" 'f' file:   open the filename under cursor
			nnoremap [cscope]f :cs find f <C-R>=expand("<cfile>")<CR><CR>
			"nnoremap <C-\>f :tab split<CR>:execute "cs find f " . expand("<cword>")<CR>
			" 'i' includes: find files that include the filename under cursor
			"nnoremap [cscope]i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
			"nnoremap <C-\>i :tab split<CR>:execute "cs find i ^" . expand("<cword>") . "$"<CR>
			nnoremap [cscope]i :cs find i <C-R>=expand("<cfile>")<CR><CR>
			"nnoremap <C-\>i :tab split<CR>:execute "cs find i " . expand("<cword>")<CR>
			" 'd' called: find functions that function under cursor calls
			nnoremap [cscope]d :cs find d <C-R>=expand("<cword>")<CR><CR>
			"nnoremap <C-\>d :tab split<CR>:execute "cs find d " . expand("<cword>")<CR>
		endif
	endif

"}}}

" Grep, quickfix list and location list "{{{
" ---------------------------------------------------------------------
" Grep, quickfix list and location list settings

	" wildignore
	:set wildignore+=.git/**,.svn/**,core.*,cscope.*,*.tags,tags

	" vimgrep the selected text in current directory
	vnoremap <silent> fd :call VisualSelection('d')<CR>

	" vimgrep current word in current directory and put the cursor in the right position
	nnoremap <Leader>fd :vimgrep /\<<C-r>=expand("<cword>")<CR>\>/j **/*<Left><Left><Left><Left><Left><Left><Left><Left><Left>

	" vimgrep current word in current file
	nnoremap <Leader>ff :vimgrep /\<<C-r>=expand("<cword>")<CR>\>/j <C-R>%

	" search and replace the selected text
	vnoremap <Leader>fr :call VisualSelection('r')<CR>

	" search and replace current word
	nnoremap <Leader>fr :%s/\<<C-r>=expand("<cword>")<CR>\>/

	" toggle list
	nnoremap <silent> <Leader>q :call ToggleList("Quickfix List", 'c')<CR>
	nnoremap <silent> <Leader>l :call ToggleList("Location List", 'l')<CR>

" }}}

" Misc "{{{
" ---------------------------------------------------------------------
" Misc settings

	" toggle just text
	nnoremap <silent> <Leader>j :call JustTextToggle()<CR>
	vnoremap <silent> <Leader>j :call JustTextToggle()<CR>

	" repeatable copy and paste. fake the behavior in windows
	nnoremap <Leader>y "zyiw
	nnoremap <Leader>p viw"zp
	vnoremap <Leader>y "zy
	vnoremap <Leader>p "zp

	" remove the Windows ^M - when the encodings gets messed up
	noremap <Leader>m mmHmt:%s/<C-V><CR>//ge<CR>'tzt'm

	" session
	"command! S mksession!
	command! S :SaveSession!
	command! O :OpenSession!

" }}}

" Helper functions "{{{
" ---------------------------------------------------------------------
" Helper functions settings

	" toggle just text
	function! JustTextToggle()
		if !exists('b:just_text')
			let b:just_text = 0
		endif
		if b:just_text == 0
			setlocal paste
			setlocal nolist
			setlocal nonumber
			setlocal noautoindent
			setlocal nocindent
			setlocal nosmartindent
			let b:just_text = 1
			echo 'Just text: on'
			return 0
		else
			setlocal nopaste
			setlocal list
			setlocal number
			setlocal autoindent
			setlocal cindent
			setlocal smartindent
			let b:just_text = 0
			echo 'Just text: off'
			return 1
		endif
		" vim-signify
		if exists("*sy#toggle")
			call sy#toggle()
		endif
	endfunction

	" highlight all instances of word under cursor, when idle.
	" useful when studying strange source code.
	if has("autocmd")
		function! AutoHighlightToggle()
			let @/ = ''
			if exists('#auto_highlight')
				autocmd! auto_highlight
				augroup! auto_highlight
				setlocal updatetime=4000
				"echo 'Highlight current word: off'
				return 0
			else
				augroup auto_highlight
					autocmd!
					" 3match conflicts with airline
					autocmd CursorHold * silent! execute printf('2match WarningMsg /\<%s\>/', expand('<cword>'))
				augroup end
				setlocal updatetime=20
				"echo 'Highlight current word: on'
				return 1
			endif
		endfunction
	endif

	" auto highlight
	if has("autocmd")
		"nnoremap <Leader>h :if AutoHighlightToggle()<Bar>set hlsearch<Bar>endif<CR>
		nnoremap <Leader>h :call AutoHighlightToggle()<CR>
		call AutoHighlightToggle()
	endif

	function! CmdLine(str)
		execute "menu Foo.Bar :" . a:str
		emenu Foo.Bar
		unmenu Foo
	endfunction

	function! VisualSelection(direction) range
		let l:saved_reg = @"
		execute "normal! vgvy"

		let l:pattern = escape(@", '\\/.*$^~[]')
		let l:pattern = substitute(l:pattern, "\n$", "", "")

		if a:direction == 'b'
			execute "normal ?" . l:pattern . "^M"
		elseif a:direction == 'f'
			execute "normal /" . l:pattern . "^M"
		elseif a:direction == 'd'
			call CmdLine("vimgrep " . '/' . l:pattern . '/j' . ' **/*.')
		elseif a:direction == 'r'
			call CmdLine("%s" . '/' . l:pattern . '/')
		endif

		let @/ = l:pattern
		let @" = l:saved_reg
	endfunction

	" toggle quickfix list and location list
	function! GetBufferList()
		redir =>buflist
		silent! ls
		redir END
		return buflist
	endfunction

	function! ToggleList(bufname, pfx)
		let buflist = GetBufferList()
		for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "' . a:bufname . '"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
			if bufwinnr(bufnum) != -1
				execute a:pfx . 'close'
				return
			endif
		endfor
		if a:pfx == 'l' && len(getloclist(0)) == 0
			echohl ErrorMsg
			echo "Location List is Empty."
			return
		endif
		let winnr = winnr()
		execute a:pfx . 'window'
		if winnr() != winnr
			wincmd p
		endif
	endfunction

" }}}

" Plugins "{{{
" ---------------------------------------------------------------------
" Plugins settings

	" NERDTree
	let g:NERDTreeWinPos = "right"
	let g:NERDTreeWinSize = 40
	let g:NERDTreeShowLineNumbers = 0
	let g:NERDTreeIgnore=['\.git','\.hg','\.svn']

	" Tagbar
	if s:use_local_bin != 0
		let g:tagbar_ctags_bin = '~/local/bin/ctags'
	endif
	let g:tagbar_left = 1
	let g:tagbar_width = 30
	let g:tagbar_autoclose = 1

	" fencview
	let g:fencview_autodetect = 0
	let g:fencview_checklines = 100
	let g:fencview_auto_patterns = '*'

	" airline
	let g:airline_mode_map = {
		\ '__' : '-',
		\ 'n'  : 'N',
		\ 'i'  : 'I',
		\ 'R'  : 'R',
		\ 'c'  : 'C',
		\ 'v'  : 'V',
		\ 'V'  : 'V',
		\ '^V' : 'V',
		\ 's'  : 'S',
		\ 'S'  : 'S',
		\ '^S' : 'S',
		\ }
	let g:airline#extensions#bufferline#enabled = 0
	let g:airline#extensions#bufferline#overwrite_variables = 1
	let g:airline#extensions#tabline#enabled = 1
	let g:airline#extensions#tabline#buffer_nr_show = 1
	let g:airline#extensions#syntastic#enabled = 1

	" session
	let g:session_autoload = 'no'
	let g:session_autosave = 'no'

" }}}


" vim:foldmethod=marker:foldlevel=0
