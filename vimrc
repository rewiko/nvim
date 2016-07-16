" detect OS {{{
  let s:is_windows = has('win32') || has('win64')
  let s:is_cygwin = has('win32unix')
  let s:is_macvim = has('gui_macvim')
  let s:is_neovim = has('nvim')
"}}}

" nvim settings {{{
  if !exists('g:nvim_settings') || !exists('g:nvim_settings.version')
    echom 'The g:nvim_settings and g:nvim_settings.version variables must be defined.  Please consult the README.'
    finish
  endif

  let s:cache_dir = get(g:nvim_settings, 'cache_dir', '~/.config/nvim/.cache')

  if g:nvim_settings.version != 1
    echom 'The version number in your shim does not match the distribution version.  Please consult the README changelog section.'
    finish
  endif

  " initialize default settings
  let s:settings = {}
  let s:settings.encoding = 'utf-8'
  let s:settings.default_indent = 2
  let s:settings.max_column = 120
  let s:settings.explorer_plugin = 'nerdtree'
  "let s:settings.explorer_plugin = 'vimfiler'
  let s:settings.statusline_plugin = 'airline'
  let s:settings.enable_cursorcolumn = 0
  "let s:settings.colorscheme = 'jellybeans'
  let s:settings.colorscheme = 'solarized'
  let s:settings.autocomplete_plugin = 'none'
  if g:nvim_settings.autocomplete != 0
    if s:is_neovim && has('python3')
      let s:settings.autocomplete_plugin = 'deoplete'
    elseif (has('python3') || has('python')) &&
        \ filereadable(expand("~/.config/nvim/bundle/repos/github.com/Valloric/YouCompleteMe/third_party/ycmd/ycm_core.so")) &&
        \ filereadable(expand("~/.config/nvim/bundle/repos/github.com/Valloric/YouCompleteMe/third_party/ycmd/ycm_client_support.so"))
      let s:settings.autocomplete_plugin = 'ycm'
    elseif has('lua')
      let s:settings.autocomplete_plugin = 'neocomplete'
    else
      let s:settings.autocomplete_plugin = 'neocomplcache'
    endif
  endif

  if exists('g:nvim_settings.plugin_groups')
    let s:settings.plugin_groups = g:nvim_settings.plugin_groups
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
    if !exists('g:nvim_settings.plugin_groups_exclude')
      let g:nvim_settings.plugin_groups_exclude = ['web','javascript','ruby','python','go','scala']
    endif
    for group in g:nvim_settings.plugin_groups_exclude
      let i = index(s:settings.plugin_groups, group)
      if i != -1
        call remove(s:settings.plugin_groups, i)
      endif
    endfor

    if exists('g:nvim_settings.plugin_groups_include')
      for group in g:nvim_settings.plugin_groups_include
        call add(s:settings.plugin_groups, group)
      endfor
    endif
  endif

  " override defaults with the ones specified in g:nvim_settings
  for key in keys(s:settings)
    if has_key(g:nvim_settings, key)
      let s:settings[key] = g:nvim_settings[key]
    endif
  endfor
"}}}

" setup & dein {{{
  set nocompatible
  set all& "reset everything to their defaults
  set runtimepath+=~/.config/nvim/bundle/repos/github.com/Shougo/dein.vim
  call dein#begin(expand('~/.config/nvim/bundle'))
  call dein#add('Shougo/dein.vim')
  call dein#local('~/.config/nvim/bundle_dev')
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
    let _s = @/
    let l = line(".")
    let c = col(".")
    " do the business:
    execute a:command
    " clean up: restore previous search history, and cursor position
    let @/ = _s
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
    " never bdelete a nerd tree
    if matchstr(expand("%"), 'NERD') ==# 'NERD'
      wincmd c
      return
    endif

    let number_of_windows_to_this_buffer = len(filter(range(1, winnr('$')), "winbufnr(v:val) == bufnr('%')"))

    if number_of_windows_to_this_buffer > 1
      wincmd c
    else
      bdelete
    endif
  endfunction "}}}
"}}}

" base configuration {{{
  set timeoutlen=300  "mapping timeout
  set ttimeoutlen=50  "keycode timeout

  set mouse=a  "enable mouse
  set mousehide  "hide when characters are typed
  set history=1000  "number of command lines to remember
  set ttyfast  "assume fast terminal connection
  set viewoptions=folds,options,cursor,unix,slash  "unix/windows compatibility
  if exists('$TMUX')
    set clipboard=
  else
    set clipboard=unnamed  "sync with OS clipboard
  endif
  set hidden  "allow buffer switching without saving
  set autoread  "auto reload if file saved externally
  set fileformats+=mac  "add mac to auto-detection of file format line endings
  set nrformats-=octal  "always assume decimal numbers
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

  set noshelltemp  "use pipes

  " whitespace
  set backspace=indent,eol,start  "allow backspacing everything in insert mode
  set autoindent  "automatically indent to match adjacent lines
  set expandtab  "spaces instead of tabs
  set smarttab  "use shiftwidth to enter tabs
  let &tabstop = s:settings.default_indent  "number of spaces per tab for display
  let &softtabstop = s:settings.default_indent  "number of spaces per tab in insert mode
  let &shiftwidth = s:settings.default_indent  "number of spaces when indenting
  set list  "highlight whitespace
  set shiftround
  set linebreak

  set scrolloff=1  "always show content after scroll
  set scrolljump=5  "minimum number of lines to scroll
  set display+=lastline
  set wildmenu  "show list for autocomplete
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
  set hlsearch  "highlight searches
  set incsearch  "incremental searching
  set ignorecase  "ignore case for searching
  set smartcase  "do case-sensitive if there's a capital letter
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

  let mapleader = ','
  let g:mapleader = ','
"}}}

" ui configuration {{{
  set showmatch  "automatically highlight matching braces/brackets/etc.
  set matchtime=2  "tens of a second to show matching parentheses
  set number
  set lazyredraw
  set laststatus=2
  set noshowmode
  set foldenable  "enable folds by default
  set foldmethod=syntax  "fold via syntax of files
  set foldlevelstart=99  "open all folds by default
  let g:xml_syntax_folding = 1  "enable xml folding

  set cursorline
  autocmd WinLeave * setlocal nocursorline
  autocmd WinEnter * setlocal cursorline
  let &colorcolumn = s:settings.max_column
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

    set guioptions+=t  "tear off menu items
    set guioptions-=T  "toolbar icons

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
    if $COLORTERM ==# 'gnome-terminal'
      set t_Co=256  "why you no tell me correct colors?!?!
    endif
    if $TERM_PROGRAM ==# 'iTerm.app'
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
    call dein#add('matchit.zip')
    if s:settings.statusline_plugin ==# 'airline' "{{{
      "if s:settings.encoding ==# 'utf-8' && has('multi_byte') && has('unix') && &encoding ==# 'utf-8' &&
      "    \ (empty(&termencoding) || &termencoding ==# 'utf-8') "{{{
        call dein#add('vim-airline/vim-airline') "{{{
          let g:airline_powerline_fonts = g:nvim_settings.powerline_fonts
          let g:airline_section_b = ''
          let g:airline_section_warning = ''
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
          let g:airline#extensions#tabline#buffers_label = 'b'
          let g:airline#extensions#tabline#tabs_label = 't'
          let g:airline#extensions#tabline#buffer_nr_show = 1
          let g:airline#extensions#tabline#buffer_nr_format = '%s '
          let g:airline#extensions#tabline#fnamecollapse = 1
          let g:airline#extensions#tabline#fnametruncate = 12
          let g:airline#extensions#syntastic#enabled = 1
        "}}}
        call dein#add('vim-airline/vim-airline-themes')
      "endif "}}}
    "}}}
    elseif s:settings.statusline_plugin ==# 'lightline' "{{{
      "call dein#add('zefei/vim-wintabs')
      "call dein#add('bling/vim-bufferline') "{{{
      "  function! LightLineBufferline()
      "    "if !empty(glob("lightline.vim"))
      "    if exists('*bufferline#refresh_status')
      "      call bufferline#refresh_status()
      "    endif
      "    let b = g:lightline_buffer_status_info.before
      "    let c = g:lightline_buffer_status_info.current
      "    let a = g:lightline_buffer_status_info.after
      "    return b . c . a
      "  endfunction
      ""}}}
      call dein#add('itchyny/lightline.vim') "{{{
        set showtabline=2  " always show tabline

        function! LightlineTag()
          " :help tagbar-statusline
          let line = tagbar#currenttag('%s', '')
          return line
        endfunction

        function! LightlineSyntastic()
          return SyntasticStatuslineFlag()
        endfunction

        function! LightlineModified()
          return &ft =~? 'help' ? '' : &modified ? g:lightline_buffer_modified_icon : &modifiable ? '' : '-'
        endfunction

        function! LightlineReadonly()
          return &ft !~? 'help' && &readonly ? g:lightline_buffer_readonly_icon : ''
        endfunction

        function! LightlineFugitive()
          if exists('*fugitive#head')
            let _ = fugitive#head()
            return strlen(_) ? g:lightline_buffer_git_icon . _ : ''
          endif
          return ''
        endfunction

        function! LightlineFileinfo()
          return LightlineFileencoding() . ' ' . LightlineFileformat()
        endfunction

        function! LightlineFilename()
          let fname = expand('%:.')
          return fname ==# 'ControlP' ? g:lightline.ctrlp_item :
              \ fname ==# '__Tagbar__' ? g:lightline.fname :
              \ fname =~# '__Gundo\|NERD_tree' ? '' :
              \ &ft ==# 'vimfiler' ? vimfiler#get_status_string() :
              \ &ft ==# 'unite' ? unite#get_status_string() :
              \ &ft ==# 'vimshell' ? vimshell#get_status_string() :
              \ ('' !=# LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
              \ ('' !=# fname ? fname : '[No Name]') .
              \ ('' !=# LightlineModified() ? ' ' . LightlineModified() : '')
        endfunction

        function! LightlineFileformat()
          return winwidth(0) > 70 ? &fileformat : ''
        endfunction

        function! LightlineFiletype()
          return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
        endfunction

        function! LightlineFileencoding()
          return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
        endfunction

        function! LightlineMode()
          let fname = expand('%:t')
          return fname ==# '__Tagbar__' ? 'Tagbar' :
              \ fname ==# 'ControlP' ? 'CtrlP' :
              \ fname ==# '__Gundo__' ? 'Gundo' :
              \ fname ==# '__Gundo_Preview__' ? 'Gundo Preview' :
              \ fname =~# 'NERD_tree' ? 'NERDTree' :
              \ &ft ==# 'unite' ? 'Unite' :
              \ &ft ==# 'vimfiler' ? 'VimFiler' :
              \ &ft ==# 'vimshell' ? 'VimShell' :
              \ winwidth(0) > 60 ? lightline#mode() : ''
        endfunction

        function! CtrlPMark()
          if expand('%:t') =~# 'ControlP'
            call lightline#link('iR'[g:lightline.ctrlp_regex])
            return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item, g:lightline.ctrlp_next], 0)
          else
            return ''
          endif
        endfunction

        let g:ctrlp_status_func = {
            \ 'main': 'CtrlPStatusFunc_1',
            \ 'prog': 'CtrlPStatusFunc_2',
            \ }

        function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
          let g:lightline.ctrlp_regex = a:regex
          let g:lightline.ctrlp_prev = a:prev
          let g:lightline.ctrlp_item = a:item
          let g:lightline.ctrlp_next = a:next
          return lightline#statusline(0)
        endfunction

        function! CtrlPStatusFunc_2(str)
          return lightline#statusline(0)
        endfunction

        let g:tagbar_status_func = 'TagbarStatusFunc'

        function! TagbarStatusFunc(current, sort, fname, ...) abort
          let g:lightline.fname = a:fname
          return lightline#statusline(0)
        endfunction

        augroup AutoSyntastic
          autocmd!
          autocmd BufWritePost *.c,*.cpp call s:syntastic()
        augroup END
        function! s:syntastic()
          SyntasticCheck
          call lightline#update()
        endfunction

        " disable overwriting the statusline forcibly by other plugins
        let g:unite_force_overwrite_statusline = 0
        let g:vimfiler_force_overwrite_statusline = 0
        let g:vimshell_force_overwrite_statusline = 0

      "}}}
      call dein#add('taohex/lightline-buffer', {'depends': 'itchyny/lightline.vim'})
      call dein#add('taohex/lightline-solarized', {'depends': 'itchyny/lightline.vim'})
    endif "}}}
    call dein#add('tpope/vim-surround')
    call dein#add('tpope/vim-repeat')
    call dein#add('tpope/vim-dispatch')
    call dein#add('tpope/vim-eunuch')
    call dein#add('tpope/vim-unimpaired') "{{{
      nmap <C-Up> [e
      nmap <C-Down> ]e
      vmap <C-Up> [egv
      vmap <C-Down> ]egv
    "}}}
    call dein#add('Shougo/vimproc.vim', {
        \ 'build': {
        \ 'mac': 'make -f make_mac.mak',
        \ 'unix': 'make -f make_unix.mak',
        \ 'cygwin': 'make -f make_cygwin.mak',
        \ 'windows': '"C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\nmake.exe" make_msvc32.mak',
        \ },
        \ })
  endif "}}}
  if count(s:settings.plugin_groups, 'web') "{{{
    call dein#add('groenewege/vim-less', {'on_ft': 'less'})
    call dein#add('cakebaker/scss-syntax.vim', {'on_ft': ['scss','sass']})
    call dein#add('hail2u/vim-css3-syntax', {'on_ft': ['css','scss','sass']})
    call dein#add('ap/vim-css-color', {'on_ft': ['css','scss','sass','less','styl']})
    call dein#add('othree/html5.vim', {'on_ft': 'html'})
    call dein#add('wavded/vim-stylus', {'on_ft': 'styl'})
    call dein#add('digitaltoad/vim-jade', {'on_ft': 'jade'})
    call dein#add('mustache/vim-mustache-handlebars', {'on_ft': ['mustache','handlebars']})
    call dein#add('gregsexton/MatchTag', {'on_ft': ['html','xml']})
    call dein#add('mattn/emmet-vim', {'on_ft': ['html','xml','xsl','xslt','xsd','css','sass','scss','less',
        \ 'mustache','handlebars']}) "{{{
      function! s:zen_html_tab()
        if !emmet#isExpandable()
          return "\<plug>(emmet-move-next)"
        endif
        return "\<plug>(emmet-expand-abbr)"
      endfunction
      autocmd FileType xml,xsl,xslt,xsd,css,sass,scss,less,mustache imap <buffer><Tab> <C-y>,
      autocmd FileType html imap <buffer><expr><Tab> <SID>zen_html_tab()
    "}}}
  endif "}}}
  if count(s:settings.plugin_groups, 'language') "{{{
    " run `:UpdateTypesFile` to highlight ctags symbols
    call dein#add('TagHighlight')
    call dein#add('gtags.vim')
    call dein#add('gdbmgr')
  endif "}}}
  if count(s:settings.plugin_groups, 'c') "{{{
    call dein#add('a.vim', {'on_ft': ['c','cpp']})
    call dein#add('c.vim', {'on_ft': ['c','cpp']})
    call dein#add('echofunc.vim', {'on_ft': ['c','cpp']})
    call dein#add('STL-improved', {'on_ft': ['c','cpp']})
    call dein#add('octol/vim-cpp-enhanced-highlight', {'on_ft': ['c','cpp']})
  endif "}}}
  if count(s:settings.plugin_groups, 'javascript') "{{{
    call dein#add('marijnh/tern_for_vim', {'on_ft': 'javascript',
        \ 'build': {
        \ 'mac': 'npm install',
        \ 'unix': 'npm install',
        \ 'cygwin': 'npm install',
        \ 'windows': 'npm install',
        \ },
        \ })
    call dein#add('pangloss/vim-javascript', {'on_ft': 'javascript'})
    call dein#add('mxw/vim-jsx', {'on_ft': 'javascript'}) "{{{
      let g:jsx_ext_required = 0
      "let g:jsx_pragma_required = 1
    "}}}
    call dein#add('maksimr/vim-jsbeautify', {'on_ft': 'javascript'}) "{{{
      nnoremap <Leader>fjs :call JsBeautify()<CR>
    "}}}
    call dein#add('leafgarland/typescript-vim', {'on_ft': 'typescript'})
    call dein#add('kchmck/vim-coffee-script', {'on_ft': 'coffee'})
    call dein#add('mmalecki/vim-node.js', {'on_ft': 'javascript'})
    call dein#add('leshill/vim-json', {'on_ft': ['javascript','json']})
    call dein#add('othree/javascript-libraries-syntax.vim', {'on_ft': ['javascript','coffee','ls','typescript']})
  endif "}}}
  if count(s:settings.plugin_groups, 'ruby') "{{{
    call dein#add('tpope/vim-rails')
    call dein#add('tpope/vim-bundler')
  endif "}}}
  if count(s:settings.plugin_groups, 'python') "{{{
    call dein#add('klen/python-mode', {'on_ft': 'python'}) "{{{
      let g:pymode_rope = 0
    "}}}
    call dein#add('davidhalter/jedi-vim', {'on_ft': 'python'}) "{{{
      let g:jedi#popup_on_dot = 0
    "}}}
  endif "}}}
  if count(s:settings.plugin_groups, 'scala') "{{{
    call dein#add('derekwyatt/vim-scala')
    call dein#add('megaannum/vimside')
  endif "}}}
  if count(s:settings.plugin_groups, 'go') "{{{
    call dein#add('jnwhiteh/vim-golang', {'on_ft': 'go'})
    call dein#add('nsf/gocode', {'on_ft': 'go', 'rtp': 'vim'})
  endif "}}}
  if count(s:settings.plugin_groups, 'scm') "{{{
    if s:settings.encoding ==# 'utf-8' && has('multi_byte') && has('unix') && &encoding ==# 'utf-8' &&
        \ (empty(&termencoding) || &termencoding ==# 'utf-8') "{{{
      call dein#add('mhinz/vim-signify') "{{{
        let g:signify_update_on_bufenter = 0
      "}}}
    endif "}}}
    "if executable('hg')
    "  call dein#add('bitbucket:ludovicchabant/vim-lawrencium')
    "endif
    call dein#add('tpope/vim-fugitive') "{{{
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
    call dein#add('gregsexton/gitv', {'depends': 'tpope/vim-fugitive', 'on_cmd': 'Gitv'}) "{{{
      nnoremap <silent> <Leader>gv :Gitv<CR>
      nnoremap <silent> <Leader>gV :Gitv!<CR>
    "}}}
  endif "}}}
  if count(s:settings.plugin_groups, 'autocomplete') "{{{
    call dein#add('honza/vim-snippets')
    if s:settings.autocomplete_plugin ==# 'ycm' "{{{
      call dein#add('Valloric/YouCompleteMe') "{{{
        "let g:ycm_path_to_python_interpreter='~/local/bin/python'
        let g:ycm_complete_in_comments_and_strings = 1
        let g:ycm_key_list_select_completion = ['<C-n>','<Down>']
        let g:ycm_key_list_previous_completion = ['<C-p>','<Up>']
        let g:ycm_filetype_blacklist = {'unite': 1}
      "}}}
      call dein#add('SirVer/ultisnips') "{{{
        let g:UltiSnipsExpandTrigger = "<Tab>"
        let g:UltiSnipsJumpForwardTrigger = "<Tab>"
        let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"
        let g:UltiSnipsSnippetsDir = '~/.vim/snippets'
      "}}}
    else
      call dein#add('Shougo/neosnippet-snippets')
      call dein#add('Shougo/neosnippet.vim') "{{{
        let g:neosnippet#snippets_directory = '~/.config/nvim/bundle/vim-snippets/snippets,~/.config/nvim/snippets'
        let g:neosnippet#enable_snipmate_compatibility = 1

        imap <expr><Tab> neosnippet#expandable_or_jumpable() ?
            \ "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ? "\<C-n>" : "\<Tab>")
        smap <expr><Tab> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"
        imap <expr><S-Tab> pumvisible() ? "\<C-p>" : ""
        smap <expr><S-Tab> pumvisible() ? "\<C-p>" : ""
      "}}}
    endif "}}}
    if s:settings.autocomplete_plugin ==# 'deoplete' "{{{
      call dein#add('Shougo/deoplete.nvim', {'on_i': 1}) "{{{
        let g:deoplete#enable_at_startup = 1
      "}}}
    elseif s:settings.autocomplete_plugin ==# 'neocomplete' "{{{
      call dein#add('Shougo/neocomplete.vim', {'on_i': 1}) "{{{
        let g:neocomplete#enable_at_startup = 1
        let g:neocomplete#data_directory = s:get_cache_dir('neocomplete')
      "}}}
    elseif s:settings.autocomplete_plugin ==# 'neocomplcache' "{{{
      call dein#add('Shougo/neocomplcache.vim', {'on_i': 1}) "{{{
        let g:neocomplcache_enable_at_startup = 1
        let g:neocomplcache_temporary_dir = s:get_cache_dir('neocomplcache')
        let g:neocomplcache_enable_fuzzy_completion = 1
      "}}}
    endif "}}}
    if s:settings.autocomplete_plugin ==# 'neocomplete' || s:settings.autocomplete_plugin ==# 'neocomplcache' "{{{
      call dein#add('osyo-manga/vim-marching', {'on_i': 1}) "{{{
        " path to clang command
        let g:marching_clang_command = "/usr/bin/clang"
      "}}}
      call dein#add('Konfekt/FastFold', {'on_i': 1})
    endif "}}}
  endif "}}}
  if count(s:settings.plugin_groups, 'editing') "{{{
    call dein#add('editorconfig/editorconfig-vim', {'on_i': 1})
    "call dein#add('tpope/vim-endwise')
    call dein#add('tpope/vim-speeddating')
    call dein#add('thinca/vim-visualstar')
    "call dein#add('tomtom/tcomment_vim')
    call dein#add('terryma/vim-expand-region')
    call dein#add('terryma/vim-multiple-cursors')
    "call dein#add('chrisbra/NrrwRgn')
    "call dein#add('godlygeek/tabular', {'on_cmd': 'Tabularize'}) "{{{
    "  nmap <Leader>a& :Tabularize /&<CR>
    "  vmap <Leader>a& :Tabularize /&<CR>
    "  nmap <Leader>a= :Tabularize /=<CR>
    "  vmap <Leader>a= :Tabularize /=<CR>
    "  nmap <Leader>a: :Tabularize /:<CR>
    "  vmap <Leader>a: :Tabularize /:<CR>
    "  nmap <Leader>a:: :Tabularize /:\zs<CR>
    "  vmap <Leader>a:: :Tabularize /:\zs<CR>
    "  nmap <Leader>a, :Tabularize /,<CR>
    "  vmap <Leader>a, :Tabularize /,<CR>
    "  nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
    "  vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
    ""}}}
    "call dein#add('jiangmiao/auto-pairs')
    call dein#add('justinmk/vim-sneak') "{{{
      let g:sneak#streak = 1
    "}}}
  endif "}}}
  if count(s:settings.plugin_groups, 'navigation') "{{{
    call dein#add('yonchu/accelerated-smooth-scroll')
    call dein#add('mileszs/ack.vim') "{{{
      if executable('ag')
        let g:ackprg = "ag --nogroup --column --smart-case --follow"
      endif
    "}}}
    call dein#add('mbbill/undotree', {'on_cmd': 'UndotreeToggle'}) "{{{
      let g:undotree_WindowLayout = 2
      let g:undotree_SetFocusWhenToggle = 1
      nnoremap <silent> <Leader>u :UndotreeToggle<CR>
    "}}}
    call dein#add('EasyGrep', {'on_cmd': 'GrepOptions'}) "{{{
      let g:EasyGrepRecursive = 1
      let g:EasyGrepAllOptionsInExplorer = 1
      let g:EasyGrepCommand = 1
      nnoremap <Leader>vo :GrepOptions<CR>
    "}}}
    call dein#add('ctrlpvim/ctrlp.vim', {'depends': 'tacahiroy/ctrlp-funky', 'on_cmd': 'CtrlP'}) "{{{
      let g:ctrlp_clear_cache_on_exit = 1
      let g:ctrlp_max_height = 40
      let g:ctrlp_show_hidden = 0
      let g:ctrlp_follow_symlinks = 1
      let g:ctrlp_max_files = 20000
      let g:ctrlp_cache_dir = s:get_cache_dir('ctrlp')
      let g:ctrlp_reuse_window = 'startify'
      let g:ctrlp_extensions = ['funky']
      let g:ctrlp_custom_ignore = {
          \ 'dir': '\v[\/]\.(git|hg|svn|idea)$',
          \ 'file': '\v\.DS_Store$'
          \ }

      if executable('ag')
        let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
      endif

      nmap \ [ctrlp]
      nnoremap [ctrlp] <Nop>

      nnoremap [ctrlp]t :CtrlPBufTag<CR>
      nnoremap [ctrlp]T :CtrlPTag<CR>
      nnoremap [ctrlp]l :CtrlPLine<CR>
      nnoremap [ctrlp]o :CtrlPFunky<CR>
      nnoremap [ctrlp]b :CtrlPBuffer<CR>
    "}}}
    if s:settings.explorer_plugin ==# 'nerdtree' "{{{
      "if s:settings.encoding == 'utf-8' && has('multi_byte') && has('unix') && &encoding == 'utf-8' &&
      "    \ (empty(&termencoding) || &termencoding == 'utf-8') "{{{
      "call dein#add('scrooloose/nerdtree', {'on_cmd': ['NERDTreeToggle','NERDTreeFind']}) "{{{
      call dein#add('scrooloose/nerdtree') "{{{
        let g:NERDTreeShowHidden = 1
        let g:NERDTreeQuitOnOpen = 0
        let g:NERDTreeShowLineNumbers = 0
        let g:NERDTreeChDirMode = 0
        let g:NERDTreeShowBookmarks = 1
        let g:NERDTreeIgnore = ['\.git','\.hg','\.svn','\.DS_Store']
        let g:NERDTreeWinPos = 'right'
        let g:NERDTreeWinSize = 40
        let g:NERDTreeBookmarksFile = s:get_cache_dir('nerdtreebookmarks')
        nnoremap <silent> <Leader>n :NERDTreeToggle<CR>
        nnoremap <silent> <Leader>nf :NERDTreeFind<CR>
        " close vim if the only window left open is a nerdtree
        autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType ==# "primary") | q | endif
      "}}}
      call dein#add('Xuyuanp/nerdtree-git-plugin') "{{{
      "}}}
      "endif "}}}
    endif "}}}
    if s:settings.explorer_plugin ==# 'vimfiler' "{{{
      call dein#add('Shougo/vimfiler.vim') "{{{
        let g:vimfiler_as_default_explorer = 1
        let g:vimfiler_ignore_pattern = '^\%(\.git\|\.hg\|\.svn\|\.DS_Store\)$'
        let g:vimfiler_no_default_key_mappings = 1
        let g:vimfiler_expand_jump_to_first_child = 0
        let g:vimfiler_data_directory = s:get_cache_dir('vimfiler')

        nnoremap <silent> <Leader>n :VimFilerExplorer -toggle -winwidth=40 -direction=botright<CR>
        nnoremap <silent> <Leader>nf :VimFilerExplorer -find -winwidth=40 -direction=botright<CR>
        "nnoremap <silent> <Leader>n :VimFiler -toggle -split -buffer-name=explorer -winwidth=40 -no-quit -direction=botright<CR>
        "nnoremap <silent> <Leader>nf :VimFiler -find -toggle -split -buffer-name=explorer -winwidth=40 -no-quit -direction=botright<CR>

        function! s:vimfiler_settings() "{{{
          set nonumber

          execute s:nowait_nmap() 'j' '<Plug>(vimfiler_loop_cursor_down)'
          execute s:nowait_nmap() 'k' '<Plug>(vimfiler_loop_cursor_up)'

          " Toggle mark.
          execute s:nowait_nmap() '<Space>' '<Plug>(vimfiler_toggle_mark_current_line)'
          execute s:nowait_nmap() '<S-LeftMouse>' '<Plug>(vimfiler_toggle_mark_current_line)'
          execute s:nowait_nmap() '<S-Space>' '<Plug>(vimfiler_toggle_mark_current_line_up)'
          vmap <buffer> <Space> <Plug>(vimfiler_toggle_mark_selected_lines)

          " Toggle marks in all lines.
          execute s:nowait_nmap() '*' '<Plug>(vimfiler_toggle_mark_all_lines)'
          execute s:nowait_nmap() '#' '<Plug>(vimfiler_mark_similar_lines)'
          " Clear marks in all lines.
          execute s:nowait_nmap() 'U' '<Plug>(vimfiler_clear_mark_all_lines)'

          " Copy files.
          execute s:nowait_nmap() 'c' '<Plug>(vimfiler_copy_file)'
          execute s:nowait_nmap() 'Cc' '<Plug>(vimfiler_clipboard_copy_file)'

          " Move files.
          execute s:nowait_nmap() 'm' '<Plug>(vimfiler_move_file)'
          execute s:nowait_nmap() 'Cm' '<Plug>(vimfiler_clipboard_move_file)'

          " Delete files.
          execute s:nowait_nmap() 'd' '<Plug>(vimfiler_delete_file)'

          " Rename.
          execute s:nowait_nmap() 'r' '<Plug>(vimfiler_rename_file)'

          " Make directory.
          execute s:nowait_nmap() 'K' '<Plug>(vimfiler_make_directory)'

          " New file.
          execute s:nowait_nmap() 'N' '<Plug>(vimfiler_new_file)'

          " Paste.
          execute s:nowait_nmap() 'Cp' '<Plug>(vimfiler_clipboard_paste)'

          " Execute or change directory.
          execute s:nowait_nmap() '<Enter>' '<Plug>(vimfiler_cd_or_edit)'
          execute s:nowait_nmap() 'o' '<Plug>(vimfiler_expand_or_edit)'
          execute s:nowait_nmap() 'l' '<Plug>(vimfiler_smart_l)'

          execute s:nowait_nmap() 'x' '<Plug>(vimfiler_execute_system_associated)'

          " Move to directory.
          execute s:nowait_nmap() 'h' '<Plug>(vimfiler_smart_h)'
          execute s:nowait_nmap() 'L' '<Plug>(vimfiler_switch_to_drive)'
          execute s:nowait_nmap() '~' '<Plug>(vimfiler_switch_to_home_directory)'
          execute s:nowait_nmap() '\' '<Plug>(vimfiler_switch_to_root_directory)'
          execute s:nowait_nmap() '&' '<Plug>(vimfiler_switch_to_project_directory)'
          execute s:nowait_nmap() '<C-j>' '<Plug>(vimfiler_switch_to_history_directory)'
          execute s:nowait_nmap() '<BS>' '<Plug>(vimfiler_switch_to_parent_directory)'

          execute s:nowait_nmap() 'gv' '<Plug>(vimfiler_execute_new_gvim)'
          execute s:nowait_nmap() '.' '<Plug>(vimfiler_toggle_visible_ignore_files)'
          execute s:nowait_nmap() 'H' '<Plug>(vimfiler_popup_shell)'

          " Edit file.
          execute s:nowait_nmap() 'e' '<Plug>(vimfiler_edit_file)'
          execute s:nowait_nmap() 'E' '<Plug>(vimfiler_split_edit_file)'
          execute s:nowait_nmap() 'B' '<Plug>(vimfiler_edit_binary_file)'

          " Choose action.
          execute s:nowait_nmap() 'a' '<Plug>(vimfiler_choose_action)'

          " Hide vimfiler.
          execute s:nowait_nmap() 'q' '<Plug>(vimfiler_hide)'
          " Exit vimfiler.
          execute s:nowait_nmap() 'Q' '<Plug>(vimfiler_exit)'
          " Close vimfiler.
          execute s:nowait_nmap() '-' '<Plug>(vimfiler_close)'

          execute s:nowait_nmap() 'ge' '<Plug>(vimfiler_execute_external_filer)'
          execute s:nowait_nmap() '<RightMouse>' '<Plug>(vimfiler_execute_external_filer)'

          execute s:nowait_nmap() '!' '<Plug>(vimfiler_execute_shell_command)'
          execute s:nowait_nmap() 'g?' '<Plug>(vimfiler_help)'
          execute s:nowait_nmap() 'v' '<Plug>(vimfiler_preview_file)'
          execute s:nowait_nmap() 'O' '<Plug>(vimfiler_sync_with_current_vimfiler)'
          execute s:nowait_nmap() 'go' '<Plug>(vimfiler_open_file_in_another_vimfiler)'
          execute s:nowait_nmap() '<C-g>' '<Plug>(vimfiler_print_filename)'
          execute s:nowait_nmap() 'g<C-g>' '<Plug>(vimfiler_toggle_maximize_window)'
          execute s:nowait_nmap() 'yy' '<Plug>(vimfiler_yank_full_path)'
          execute s:nowait_nmap() 'M' '<Plug>(vimfiler_set_current_mask)'
          execute s:nowait_nmap() 'gr' '<Plug>(vimfiler_grep)'
          execute s:nowait_nmap() 'gf' '<Plug>(vimfiler_find)'
          execute s:nowait_nmap() 'S' '<Plug>(vimfiler_select_sort_type)'
          execute s:nowait_nmap() '<C-v>' '<Plug>(vimfiler_switch_vim_buffer_mode)'
          execute s:nowait_nmap() 'gc' '<Plug>(vimfiler_cd_vim_current_dir)'
          execute s:nowait_nmap() 'gs' '<Plug>(vimfiler_toggle_safe_mode)'
          execute s:nowait_nmap() 'gS' '<Plug>(vimfiler_toggle_simple_mode)'
          execute s:nowait_nmap() 'gg' '<Plug>(vimfiler_cursor_top)'
          execute s:nowait_nmap() 'G' '<Plug>(vimfiler_cursor_bottom)'
          execute s:nowait_nmap() 't' '<Plug>(vimfiler_expand_tree)'
          execute s:nowait_nmap() 'T' '<Plug>(vimfiler_expand_tree_recursive)'
          execute s:nowait_nmap() 'I' '<Plug>(vimfiler_cd_input_directory)'
          execute s:nowait_nmap() '<2-LeftMouse>' '<Plug>(vimfiler_double_click)'

          " pushd/popd
          execute s:nowait_nmap() 'Y' '<Plug>(vimfiler_pushd)'
          execute s:nowait_nmap() 'P' '<Plug>(vimfiler_popd)'

          execute s:nowait_nmap() 'gj' '<Plug>(vimfiler_jump_last_child)'
          execute s:nowait_nmap() 'gk' '<Plug>(vimfiler_jump_first_child)'

        endfunction "}}}

        function! s:nowait_nmap() "{{{
          return 'nmap <buffer>'
              \ . ((v:version > 703 || (v:version == 703 && has('patch1261'))) ?
              \ '<nowait>' : '')
        endfunction "}}}

        autocmd FileType vimfiler call s:vimfiler_settings()
      "}}}
    endif "}}}
    call dein#add('majutsushi/tagbar', {'on_cmd': 'TagbarToggle'}) "{{{
      let g:tagbar_left = 1
      let g:tagbar_width = 30
      let g:tagbar_autoclose = 0
      nnoremap <silent> <Leader>t :TagbarToggle<CR>
    "}}}
    "call dein#add('jeetsukumaran/vim-buffergator') "{{{
    "  "let g:buffergator_suppress_keymaps = 1
    "  let g:buffergator_suppress_mru_switch_into_splits_keymaps = 1
    "  let g:buffergator_viewport_split_policy = "B"
    "  let g:buffergator_split_size = 10
    "  let g:buffergator_sort_regime = "mru"
    "  let g:buffergator_mru_cycle_loop = 0
    "  "nnoremap <silent> <Leader>b :BuffergatorOpen<CR>
    "  "nnoremap <silent> <Leader>B :BuffergatorClose<CR>
    "  "nnoremap <silent> <M-b> :BuffergatorMruCyclePrev<CR>
    "  "nnoremap <silent> <M-S-b> :BuffergatorMruCycleNext<CR>
    "  "nnoremap <silent> [b :BuffergatorMruCyclePrev<CR>
    "  "nnoremap <silent> ]b :BuffergatorMruCycleNext<CR>
    ""}}}
  endif "}}}
  if count(s:settings.plugin_groups, 'unite') "{{{
    "call dein#add('Shougo/unite.vim', {'on_cmd': ['Unite','UniteWithCurrentDir','UniteWithBufferDir',
    "    \ 'UniteWithProjectDir','UniteWithInput','UniteWithInputDirectory','UniteWithCursorWord']}) "{{{
    call dein#add('Shougo/unite.vim') "{{{
      function! UniteSettings() abort
        call unite#filters#matcher_default#use(['matcher_fuzzy'])
        call unite#filters#sorter_default#use(['sorter_rank'])
        call unite#custom#source('file_rec,file_rec/async', 'ignore_pattern',
            \ '\.git/\|\.hg/\|\.svn/\|\.tags$\|cscope\.\|\.taghl$\|\.DS_Store$')
        call unite#custom#profile('default', 'context', {
            \ 'start_insert': 1
            \ })
      endfunction
      call dein#set_hook('unite.vim', 'hook_source', function('UniteSettings'))

      let g:unite_data_directory = s:get_cache_dir('unite')
      let g:unite_source_history_yank_enable = 1
      let g:unite_source_rec_max_cache_files = 5000

      if executable('ag')
        let g:unite_source_grep_command = 'ag'
        let g:unite_source_grep_default_opts = '--nocolor --line-numbers --nogroup -S -C4'
        let g:unite_source_grep_recursive_opt = ''
      elseif executable('ack')
        let g:unite_source_grep_command = 'ack'
        let g:unite_source_grep_default_opts = '--no-heading --no-color -C4'
        let g:unite_source_grep_recursive_opt = ''
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
        " -auto-preview
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
    call dein#add('Shougo/neomru.vim', {'depends': 'Shougo/unite.vim'})
    "call dein#add('osyo-manga/unite-airline_themes', {'depends': 'Shougo/unite.vim'}) "{{{
    "  nnoremap <silent> [unite]a :<C-u>Unite -winheight=10 -auto-preview -buffer-name=airline_themes airline_themes<CR>
    ""}}}
    "call dein#add('ujihisa/unite-colorscheme', {'depends': 'Shougo/unite.vim'}) "{{{
    "  nnoremap <silent> [unite]c :<C-u>Unite -winheight=10 -auto-preview -buffer-name=colorschemes colorscheme<CR>
    ""}}}
    call dein#add('tsukkee/unite-tag', {'depends': 'Shougo/unite.vim'}) "{{{
      nnoremap <silent> [unite]t :<C-u>Unite -auto-resize -buffer-name=tag tag tag/file<CR>
    "}}}
    call dein#add('hewes/unite-gtags', {'depends': 'Shougo/unite.vim'}) "{{{
      " lists the references or definitions of a word
      " `global --from-here=<location of cursor> -qe <word on cursor>`
      nnoremap <silent> [unite]gg :execute 'Unite gtags/context'<CR>
      " lists definitions of a word
      " `global -qd -e <pattern>`
      nnoremap <silent> [unite]gd :execute 'Unite gtags/def:'.expand('<cword>')<CR>
      vnoremap <silent> [unite]gd <ESC>:execute 'Unite gtags/def:'.GetVisualSelection()<CR>
      " lists references of a word
      " `global -qrs -e <pattern>`
      nnoremap <silent> [unite]gr :execute 'Unite gtags/ref:'.expand('<cword>')<CR>
      vnoremap <silent> [unite]gr <ESC>:execute 'Unite gtags/ref:'.GetVisualSelection()<CR>
      " lists grep result of a word
      " `global -qg -e <pattern>`
      nnoremap <silent> [unite]ge :execute 'Unite gtags/grep:'.expand('<cword>')<CR>
      vnoremap <silent> [unite]ge <ESC>:execute 'Unite gtags/grep:'.GetVisualSelection()<CR>
      " lists all tokens in GTAGS
      " `global -c`
      nnoremap <silent> [unite]ga :execute 'Unite gtags/completion'<CR>
      " lists current file's tokens in GTAGS
      " `global -f`
      nnoremap <silent> [unite]gf :execute 'Unite gtags/file'<CR>
    "}}}
    call dein#add('Shougo/unite-outline', {'depends': 'Shougo/unite.vim'}) "{{{
      nnoremap <silent> [unite]o :<C-u>Unite -auto-resize -buffer-name=outline outline<CR>
    "}}}
    "call dein#add('Shougo/unite-help', {'depends': 'Shougo/unite.vim'}) "{{{
    "  nnoremap <silent> [unite]h :<C-u>Unite -auto-resize -buffer-name=help help<CR>
    ""}}}
    "call dein#add('Shougo/junkfile.vim', {'depends': 'Shougo/unite.vim', 'on_cmd': 'JunkfileOpen'}) "{{{
    "  let g:junkfile#directory=s:get_cache_dir('junk')
    "  nnoremap <silent> [unite]j :<C-u>Unite -auto-resize -buffer-name=junk junkfile junkfile/new<CR>
    ""}}}
  elseif s:settings.explorer_plugin ==# 'vimfiler'
    " vimfiler require unite
    call dein#add('Shougo/unite.vim')
  endif "}}}
  if count(s:settings.plugin_groups, 'indents') "{{{
    call dein#add('nathanaelkane/vim-indent-guides') "{{{
      let g:indent_guides_start_level = 1
      let g:indent_guides_guide_size = 1
      let g:indent_guides_enable_on_vim_startup = 0
      let g:indent_guides_color_change_percent = 3
      "if !has('gui_running')
      "  let g:indent_guides_auto_colors=0
      "  function! s:indent_set_console_colors()
      "    hi IndentGuidesOdd ctermbg=235
      "    hi IndentGuidesEven ctermbg=236
      "  endfunction
      "  autocmd VimEnter,Colorscheme * call s:indent_set_console_colors()
      "endif
    "}}}
  endif "}}}
  if count(s:settings.plugin_groups, 'textobj') "{{{
    call dein#add('kana/vim-textobj-user')
    call dein#add('kana/vim-textobj-indent')
    call dein#add('kana/vim-textobj-entire')
    call dein#add('lucapette/vim-textobj-underscore')
  endif "}}}
  if count(s:settings.plugin_groups, 'misc') "{{{
    if s:settings.encoding ==# 'utf-8' && has('multi_byte') && has('unix') && &encoding ==# 'utf-8' &&
        \ (empty(&termencoding) || &termencoding ==# 'utf-8') "{{{
      call dein#add('ryanoasis/vim-devicons')
    endif "}}}
    call dein#add('xolox/vim-misc')
    call dein#add('xolox/vim-session') "{{{
      let g:session_directory = s:get_cache_dir('sessions')
      let g:session_autoload = 'no'
      let g:session_autosave = 'no'
      command! S :SaveSession!
      command! O :OpenSession!
    "}}}
    call dein#add('mbbill/fencview', {'on_cmd': ['FencView','FencAutoDetect']}) "{{{
      let g:fencview_autodetect = 0
      let g:fencview_checklines = 100
      let g:fencview_auto_patterns = '*'
    "}}}
    if exists('$TMUX')
      call dein#add('christoomey/vim-tmux-navigator')
    endif
    call dein#add('kana/vim-vspec')
    call dein#add('tpope/vim-scriptease', {'on_ft': 'vim'})
    call dein#add('jtratner/vim-flavored-markdown', {'on_ft': ['markdown','ghmarkdown']})
    if executable('redcarpet') && executable('instant-markdown-d')
      call dein#add('suan/vim-instant-markdown', {'on_ft': ['markdown','ghmarkdown']})
    endif
    call dein#add('guns/xterm-color-table.vim', {'on_cmd': 'XtermColorTable'})
    "call dein#add('chrisbra/vim_faq')
    "call dein#add('vimwiki')
    call dein#add('bufkill.vim')
    call dein#add('mhinz/vim-startify') "{{{
      let g:startify_session_dir = s:get_cache_dir('sessions')
      let g:startify_change_to_vcs_root = 1
      let g:startify_show_sessions = 1

      let g:startify_custom_header = [
          \ ' nvim by taohe',
          \ '',
          \ ' <Space><Space>  go to anything (files, buffers, MRU, bookmarks)',
          \ ' <Space>gg   lists the references or definitions of a word',
          \ ' ,n        toggle the-nerd-tree',
          \ ' ,r        toggle tagbar',
          \ ' ,b        preview MRU buffers',
          \ ' ,u        toggle undo tree',
          \ ' ,q        toggle quickfix list',
          \ ' ,d        Conque-GDB',
          \ '',
          \ ]

      let g:startify_list_order = [
          \ ['   Sessions:'],
          \ 'sessions',
          \ ['   Bookmarks:'],
          \ 'bookmarks',
          \ ['   MRU:'],
          \ 'files',
          \ ['   MRU within this dir:'],
          \ 'dir',
          \ ]
    "}}}
    call dein#add('scrooloose/syntastic') "{{{
      " run `:SyntasticCheck` to check syntax
    "}}}
    call dein#add('mattn/gist-vim', {'depends': 'mattn/webapi-vim', 'on_cmd': 'Gist'}) "{{{
      let g:gist_post_private = 1
      let g:gist_show_privates = 1
    "}}}
    call dein#add('Shougo/vimshell.vim', {'on_cmd': ['VimShell','VimShellInteractive']}) "{{{
      if s:is_macvim
        let g:vimshell_editor_command = 'mvim'
      else
        let g:vimshell_editor_command = 'vim'
      endif
      let g:vimshell_right_prompt = 'getcwd()'
      let g:vimshell_data_directory = s:get_cache_dir('vimshell')
      let g:vimshell_vimshrc_path = '~/.config/nvim/vimshrc'

      "nnoremap <Leader>c :VimShell -split<CR>
      "nnoremap <Leader>cc :VimShell -split<CR>
      "nnoremap <Leader>cn :VimShellInteractive node<CR>
      "nnoremap <Leader>cl :VimShellInteractive lua<CR>
      "nnoremap <Leader>CR :VimShellInteractive irb<CR>
      "nnoremap <Leader>cp :VimShellInteractive python<CR>
    "}}}
    call dein#add('zhaocai/GoldenView.Vim', {'on_map': '<Plug>ToggleGoldenViewAutoResize'}) "{{{
      let g:goldenview__enable_default_mapping = 0
      nmap <silent> <Leader>z <Plug>ToggleGoldenViewAutoResize
    "}}}
    " do not use conque-shell together with conque-gdb
    "call dein#add('oplatek/Conque-Shell') "{{{
    "}}}
    call dein#add('vim-scripts/Conque-GDB', {'on_cmd': ['ConqueGdb','ConqueGdbTab',
        \ 'ConqueGdbVSplit','ConqueGdbSplit','ConqueTerm','ConqueTermTab',
        \ 'ConqueTermVSplit','ConqueTermSplit']}) "{{{
      let g:ConqueGdb_Leader = '\'
      nnoremap <Leader>d :ConqueGdbVSplit<CR>
    "}}}
    "call dein#add('edkolev/tmuxline.vim')
  endif "}}}
  if count(s:settings.plugin_groups, 'windows') "{{{
    call dein#add('PProvost/vim-ps1', {'on_ft': 'ps1'}) "{{{
      autocmd BufNewFile,BufRead *.ps1,*.psd1,*.psm1 setlocal ft=ps1
    "}}}
    call dein#add('nosami/Omnisharp', {'on_ft': 'cs'})
  endif "}}}
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
  vnoremap <Leader>w <Esc>:w<CR>
  inoremap <Leader>w <Esc>:w<CR>

  nnoremap <Leader>a :A<CR>

  " remap arrow keys
  nnoremap <Left> :bprev<CR>
  " :call LightLineBufferline()<CR>:call lightline#update()<CR>
  nnoremap <Right> :bnext<CR>
  " :call LightLineBufferline()<CR>:call lightline#update()<CR>
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

  if mapcheck('<Space>/') ==# ''
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

  " screen line scroll {{{
    nnoremap <silent> j gj
    nnoremap <silent> k gk
  " }}}

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

  " reselect visual block after indent {{{
    vnoremap < <gv
    vnoremap > >gv
  "}}}

  " reselect last paste {{{
    nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
  "}}}

  " find current word in quickfix {{{
  "  nnoremap <Leader>fw :execute "vimgrep ".expand("<cword>")." %"<CR>:copen<CR>
  "}}}
  " find last search in quickfix {{{
  "  nnoremap <Leader>ff :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>
  "}}}

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
  "map <Leader>tn :tabnew<CR>
  "map <Leader>tc :tabclose<CR>

  " make Y consistent with C and D. See :help Y.
  nnoremap Y y$

  " hide annoying quit message
  nnoremap <C-c> <C-c>:echo<CR>

  " window killer
  nnoremap <silent> Q :call CloseWindowOrKillBuffer()<CR>

  if dein#is_sourced('vim-dispatch')
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
  call dein#add('taohex/vim-colors-solarized') "{{{
    let g:solarized_termcolors = 256
    let g:solarized_termtrans = 1
  "}}}
  "call dein#add('nanotech/jellybeans.vim')
  call dein#add('tomasr/molokai')
  "call dein#add('chriskempson/vim-tomorrow-theme')
  "call dein#add('chriskempson/base16-vim')
  "call dein#add('w0ng/vim-hybrid')
  "call dein#add('sjl/badwolf')
  "call dein#add('zeis/vim-kolor') "{{{
  "  let g:kolor_underlined=1
  ""}}}
"}}}

" finish loading {{{
  if exists('g:nvim_settings.disabled_plugins')
    for plugin in g:nvim_settings.disabled_plugins
      dein#disable(plugin)
    endfor
  endif

  call dein#end()
  filetype plugin indent on
  syntax enable
  execute 'colorscheme ' . s:settings.colorscheme

  if dein#check_install()
    call dein#install()
  endif
  "echo exists("*sy#toggle")
"}}}


" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0

