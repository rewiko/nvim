```
                 _
   _  _ _   _  /_/_   _
  / |/ / | / // // | / |
 /    /| |/ // //  |/  |
/_/|_/ |___//_//_/|_/|_|

```

A full-blown IDE based on Neovim (or Vim).

<img src="http://taohex.github.io/images/vim.gif" width="60%"/>

**Table of Contents**

- [Introduction](#introduction)
- [Basic Installation](#basic-installation)
- [Keymap](#keymap)
- [Advanced Installation](#advanced-installation)
- [Autocomplete](#autocomplete)
- [Standard Modifications](#standard-modification)
- [Plugins](#plugins)
- [Credits](#credits)
- [License](#license)

## Introduction

A full-blown IDE based on Neovim (or Vim) with gdb and ctags support.

## Basic Installation

```sh
mkdir ~/.config/
cd ~/.config/
git clone https://github.com/taohex/nvim
cd ~/.config/nvim/
git submodule init && git submodule update
mv ~/.vim ~/.vim.backup
mv ~/.vimrc ~/.vimrc.backup
ln -s ~/.config/nvim ~/.vim
ln -s ~/.config/nvim/init.vim ~/.vimrc
```

Startup vim and neobundle will detect and ask you install any missing plugins. You can also manually initiate this with `:NeoBundleInstall`.

## Keymap

`<Leader>` default set to `,`

### Unite

Keybinding       | Description
-----------------|------------------------------------------------------------
`<Space><Space>` | go to anything (files, buffers, MRU, bookmarks)
`<Space>f`       | select from files under the current working directory
`<Space>e`       | select from MRU
`<Space>l`       | select line from current buffer
`<Space>b`       | select from current buffers
`<Space>o`       | select from outline of current file
`<Space>s`       | quick switch buffer
`<Space>/`       | recursively search all files for matching text (uses `ag` or `ack` if found)
`<Space>m`       | select from key mappings
`<Space>t`       | select from tags
`<Space>y`       | select from previous yanks
`<Space>j`       | select from junkfiles
`<Space>gg`      | lists the references or definitions of a word
`<Space>gd`      | lists definitions of a word
`<Space>gr`      | lists references of a word
`<Space>ge`      | lists grep result of a word
`<Space>ga`      | lists all tokens in GTAGS
`<Space>gf`      | lists current file's tokens in GTAGS

### Panel

Keybinding       | Mode | Description
-----------------|------|------------------------------------------------------------
`<Leader>n`      |  n   | toggle the-nerd-tree
`<Leader>nf`     |  n   | open the-nerd-tree to path of the current file
`<Leader>t`      |  n   | toggle tagbar
`<Leader>b`      |  n   | preview MRU buffers
`<Leader>u`      |  n   | toggle undo tree
`<Leader>q`      |  n   | toggle quickfix list
`<Leader>l`      |  n   | toggle location list
`<Leader>d`      |  n   | Conque-GDB

### Edit

Keybinding       | Mode | Description
-----------------|------|------------------------------------------------------------
`<Leader>y`      |  n   | windows-like copy
`<Leader>p`      |  n   | windows-like paste
`<C-h>`          |  i   | move the cursor left
`<C-l>`          |  i   | move the cursor right
`<Leader>a`      |  n   | alternate files (.c -> .h etc)
`<Leader>w`      | n, i | write buffer to file
`<Leader>s`      |  v   | sort selection
`<Leader>fef`    |  n   | format entire file
`<Leader>f$`     |  n   | strip current line of trailing white space
`jk`, `kj`       |  i   | escape
`gp`             |  n   | visually reselect the last paste
`:O`             |  n   | load default session
`:S`             |  n   | save default session
`:OpenSession`   |  n   | load a session
`:SaveSession`   |  n   | save a session

### Window & Buffer

Keybinding           | Mode | Description
---------------------|------|------------------------------------------------------------
`<Left>`, `<Right>`  |  n   | previous buffer, next buffer
`<Leader>v`          |  n   | vertical split
`<Leader>s`          |  n   | horizontal split
`<Leader>vsa`        |  n   | vertically split all buffers
`<C-h>`, `<C-l>`     |  n   | move to window in the direction of hl 
`<C-j>`, `<C-k>`     |  n   | move to window in the direction of jk
`<C-w>o`, `<C-w>O`   |  n   | maximize or restore current window in split structure
`<C-w><C-o>`         |  n   | same as above
`<Leader>=`          |  n   | increase the window size by a factor
`<Leader>-`          |  n   | decrease the window size by a factor
`Q`                  |  n   | close windows and delete the buffer (if it is the last buffer window)
`gb`, `gB`           |  n   | previous MRU buffer, next MRU buffer
`<Leader>bd`         |  n   | kill a buffer without changing the window layout

### Searching

Keybinding           | Mode | Description
---------------------|------|------------------------------------------------------------
`<Leader>fd`         | n, v | find current word (or selected text) in current directory into the quickfix list
`<Leader>ff`         |  n   | find current word in current file into the quickfix list
`<Leader>fr`         | n, v | replace current word (or selected text) in current file
`/`                  |  n   | replaced with `/\v` for sane regex searching

### View

Keybinding              | Mode | Description
------------------------|------|------------------------------------------------------------
`<Leader>j`             | n, v | toggle just text (for copy and paste)
`<Leader>h`             |  n   | toggle highlight
`<Leader>ig`            |  n   | toggle indent guides
`<Leader>z`             |  n   | toggle goldenview
`:XtermColorTable<CR>`  |  n   | show color table
`:syntax<CR>`           |  n   | show syntax highlight

### EasyGrep

Keybinding       | Description
-----------------|------------------------------------------------------------
`<Leader>vo`     | select the files to search in and set grep options (must run this first)
`<Leader>vv`     | grep for the word under the cursor, match all occurences, like |gstar|
`<Leader>vV`     | grep for the word under the cursor, match whole word, like |star|
`<Leader>va`     | like vv, but add to existing list
`<Leader>vA`     | like vV, but add to existing list
`<Leader>vr`     | perform a global search on the word under the cursor and prompt for a pattern with which to replace it
`<Leader>vR`     | same as vr, but matches whole word

### unimpaired

Keybinding       | Description
-----------------|------------------------------------------------------------
`[a`             | :previous
`]a`             | :next
`[A`             | :first
`]A`             | :last
`[b`             | :bprevious
`]b`             | :bnext
`[B`             | :bfirst
`]B`             | :blast
`[c`             | signify previous hunk
`]c`             | signify next hunk
`[l`             | :lprevious
`]l`             | :lnext
`[L`             | :lfirst
`]L`             | :llast
`[<C-L>`         | :lpfile
`]<C-L>`         | :lnfile
`[q`             | :cprevious
`]q`             | :cnext
`[Q`             | :cfirst
`]Q`             | :clast
`[<C-Q>`         | :cpfile (Note that <C-Q> only works in a terminal if you disable
`]<C-Q>`         | :cnfile flow control: stty -ixon)
`[t`             | :tprevious
`]t`             | :tnext
`[T`             | :tfirst
`]T`             | :tlast

### GLOBAL

Keybinding       | Mode | Description
-----------------|------|------------------------------------------------------------
`;g`             |  n   | go to definition or reference
`;d`             |  n   | go to definition
`;r`             |  n   | find reference
`;s`             |  n   | locate symbols which are not defined in `GTAGS`
`;e`             |  n   | locate strings
`;f`             |  n   | get a list of tags in specified files

### Cscope (Default Off)

Keybinding       | Mode | Description
-----------------|------|------------------------------------------------------------
`;s`             |  n   | find all references to the token under cursor
`;g`             |  n   | find global definition(s) of the token under cursor
`;c`             |  n   | find all calls to the function name under cursor
`;t`             |  n   | find all instances of the text under cursor
`;e`             |  n   | egrep search for the word under cursor
`;f`             |  n   | open the filename under cursor
`;i`             |  n   | find files that include the filename under cursor
`;d`             |  n   | find functions that function under cursor calls

### Profiling

Keybinding       | Mode | Description
-----------------|------|------------------------------------------------------------
`<Leader>DD`     |  n   | starts profiling all functions and files into a file `profile.log`
`<Leader>DP`     |  n   | pauses profiling
`<Leader>DC`     |  n   | continues profiling
`<Leader>DQ`     |  n   | finishes profiling and exits vim

## Advanced Installation

### OS X

YouComplete **only** support Neovim or MacVim.

#### Install Neovim (Recommended)

```sh
pip install neovim
brew update
brew reinstall --HEAD neovim
```

Make alias

```sh
alias vi='nvim'
alias vim="nvim"
alias vimdiff="nvim -d"
```

If `<C-h>` does not work in neovim, add these line to `~/.zshrc`

```sh
infocmp $TERM | sed 's/kbs=^[hH]/kbs=\\177/' > $TERM.ti
tic $TERM.ti
```

#### Install MacVim

```sh
brew install macvim --with-luajit --override-system-vim
```

Make alias

```sh
alias vi="mvim -v"
alias vim="mvim -v"
alias vimdiff="mvim -d -v"
```

#### Install GLOBAL

```sh
brew install global
```

#### Quick Compile YouCompleteMe

```sh
cd ~/.vim/bundle/YouCompleteMe
./install.sh --clang-completer --omnisharp-completer
```

Check for `~/.vim/bundle/YouCompleteMe/third_party/ycmd/ycm_client_support.so` and `~/.vim/bundle/YouCompleteMe/third_party/ycmd/ycm_core.so`, done

#### Full Compile YouCompleteMe

Try this if quick compile does not work

```sh
cd ~/.vim/bundle/
git clone https://github.com/Valloric/YouCompleteMe
cd YouCompleteMe/
git submodule update --init --recursive
```

Download clang from <http://llvm.org/releases/download.html> to `~/src/` and compile ycm_support_libs

```sh
mkdir -p ~/src/
cd ~/src/
tar xf clang+llvm-3.6.0-x86_64-apple-darwin.tar.xz
mkdir -p ~/src/ycm_build/
cd ~/src/ycm_build/
cmake -G "Unix Makefiles" -DPATH_TO_LLVM_ROOT=~/src/clang+llvm-3.6.0-x86_64-apple-darwin . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp
make ycm_support_libs
```

Check for `~/.vim/bundle/YouCompleteMe/third_party/ycmd/ycm_client_support.so` and `~/.vim/bundle/YouCompleteMe/third_party/ycmd/ycm_core.so`, done

#### Project Configuration

Download <https://raw.githubusercontent.com/Valloric/ycmd/master/cpp/ycm/.ycm_extra_conf.py> to your project directory

## Autocomplete

This distribution will pick one of three combinations, in the following priority:

1.	[youcompleteme][ycm] + [ultisnips][us] if you have compiled YCM.
1.	[neocomplete][nc] + [neosnippet][ns] if you have `lua` enabled.
1.	[neocomplcache][ncl] + [neosnippet][ns] if you only have vimscript available

this can be overridden with `g:nvim_settings.autocomplete_method`

## Standard Modifications

*	if you have either [ack](http://betterthangrep.com/) or [ag](https://github.com/ggreer/the_silver_searcher) installed, they will be used for `grepprg`
*	all temporary files are stored in `~/.vim/.cache`, such as backup files and persistent undo

## Plugins

### [unite.vim](https://github.com/Shougo/unite.vim)
*	this is an extremely powerful plugin that lets you build up lists from arbitrary sources
*	mappings
	*	`<Space><Space>` go to anything (files, buffers, MRU, bookmarks)
	*	`<Space>y` select from previous yanks
	*	`<Space>l` select line from current buffer
	*	`<Space>b` select from current buffers
	*	`<Space>o` select from outline of current file
	*	`<Space>s` quick switch buffer
	*	`<Space>/` recursively search all files for matching text (uses `ag` or `ack` if found)

### [bufkill.vim](http://www.vim.org/scripts/script.php?script_id=1147)
*	`<Leader>bd` or `:BD` will kill a buffer without changing the window layout

### [sneak.vim](https://github.com/justinmk/vim-sneak)
*	motion on steriods

### [easygrep](http://www.vim.org/scripts/script.php?script_id=2438)
*	makes search/replacing in your project a lot easier without relying on `find` and `sed`
*	the loading time of this plugin is relatively heavy, so it is not loaded at startup.  to load it on-demand, use `<Leader>vo`, which opens the options window.
*	`<Leader>vv` find word under the cursor
*	`<Leader>vV` find whole word under the cursor
*	`<Leader>vr` perform global search replace of word under cursor, with confirmation
*	`<Leader>vR` same as vr, but matches whole word

### [fugitive](https://github.com/tpope/vim-fugitive)
*	git wrapper
*	`<Leader>gs` status
*	`<Leader>gd` diff
*	`<Leader>gc` commit
*	`<Leader>gb` blame
*	`<Leader>gl` log
*	`<Leader>gp` push
*	`<Leader>gw` stage
*	`<Leader>gr` rm
*	in addition to all the standard bindings when in the git status window, you can also use `U` to perform a `git checkout --` on the current file

### [gitv](https://github.com/gregsexton/gitv)
*	nice log history viewer for git
*	`<Leader>gv`

### [unimpaired](https://github.com/tpope/vim-unimpaired)
*	many additional bracket `[]` maps
*	`<C-up>` to move lines up
*	`<C-down>` to move lines down

### [nerdtree](https://github.com/scrooloose/nerdtree)
*	file browser
*	`<Leader>n` toggle browser
*	`<Leader>nf` open tree to path of the current file

### [tcomment](https://github.com/tomtom/tcomment_vim)
*	very versatile commenting plugin that can do motions
*	`gcc` to toggle or `gc{motion}`

### [ctrlp](https://github.com/kien/ctrlp.vim)
*	fuzzy file searching
*	`<C-p>` to bring up the search
*	`\t` search the current buffer tags
*	`\T` search global tags
*	`\l` search all lines of all buffers
*	`\b` search open buffers
*	`\o` parses the current file for functions with [funky](https://github.com/tacahiroy/ctrlp-funky)

### [nrrwrgn](http://github.com/chrisbra/NrrwRgn)
*	`<Leader>nr` puts the current visual selection into a new scratch buffer, allowing you to perform global commands and merge changes to the original file automatically

### [tabular](https://github.com/godlygeek/tabular)
*	easily aligns code
*	`<Leader>a&`, `<Leader>a=`, `<Leader>a:`, `<Leader>a,`, `<Leader>a|`

### [gist](https://github.com/mattn/gist-vim)
*	automatically get or push changes for gists with `:Gist`

### [emmet](https://github.com/mattn/emmet-vim)
*	makes for writing html/css extremely fast
*	for supported most filetypes, `<tab>` will be mapped to automatically expand the line (you can use `<C-v><Tab>` to insert a tab character if needed)
*	for other features, default plugin mappings are available, which means `<C-y>` is the prefix, followed by a variety of options (see `:help zencoding`)

### [undotree](https://github.com/mbbill/undotree)
*	visualize the undo tree
*	`<Leader>u` to toggle

### [youcompleteme][ycm]/[ultisnips][us]
*	amazingly fast fuzzy autocomplete engine combined with an excellent snippets library
*	use `<C-n>` and `<C-p>` to go back/forward between selections, and `<tab>` to expand snippets

### [neocomplcache][ncl]/[neosnippet][ns]
*	autocomplete/snippet support as a fallback choice when YCM and/or python is unavailable
*	`<Tab>` to select the next match, or expand if the keyword is a snippet
*	if you have lua installed, it will use [neocomplete][nc] instead

### [vim-multiple-cursors](https://github.com/terryma/vim-multiple-cursors)
*	mapped to `<C-N>`, this will select all matching words and lets you concurrently change all matches at the same time

### [conque-gdb](https://github.com/vim-scripts/Conque-GDB)
*	`<Leader>d` gdb command line interface and terminal emulator

### [tagbar](https://github.com/majutsushi/tagbar)
*	`<Leader>ta` displays tags in a window

### [vim-buffergator](https://github.com/jeetsukumaran/vim-buffergator)
*	`<Leader>t` list, select and switch between buffers

### [goldenview](https://github.com/zhaocai/GoldenView.Vim)
*	`<Leader>z` always have a nice view for vim split windows

### And Some More Plugins

*	[surround](https://github.com/tpope/vim-surround) makes for quick work of surrounds
*	[repeat](https://github.com/tpope/vim-repeat) repeat plugin commands
*	[speeddating](https://github.com/tpope/vim-speeddating) `Ctrl+A` and `Ctrl+X` for dates
*	[gist](https://github.com/mattn/gist-vim) awesome plugin for your gist needs
*	[signature](https://github.com/kshenoy/vim-signature) shows marks beside line numbers
*	[matchit](https://github.com/vim-scripts/matchit.zip) makes your `%` more awesome
*	[syntastic](https://github.com/scrooloose/syntastic) awesome syntax checking for a variety of languages
*	[bufferline](https://github.com/bling/vim-bufferline) simple plugin which prints all your open buffers in the command bar
*	[indent-guides](https://github.com/nathanaelkane/vim-indent-guides) vertical lines
*	[signify](https://github.com/mhinz/vim-signify) adds + and - to the signs column when changes are detected to source control files (supports git/hg/svn)
*	[delimitmate](https://github.com/Raimondi/delimitMate) automagically adds closing quotes and braces
*	[startify](https://github.com/mhinz/vim-startify) gives you a better start screen

### And Even More Plugins...

*	I think I've listed about half of the plugins contained in this distribution, so please have a look at the vimrc directly to see all plugins in use

## Credits

I wanted to give special thanks to all of the people who worked on the following projects, or people simply posted their vim distributions, because I learned a lot and took many ideas and incorporated them into my configuration.

*	[bling](https://github.com/bling/dotvim)
*	[janus](https://github.com/carlhuda/janus)
*	[spf13](https://github.com/spf13/spf13-vim)
*	[yadr](http://skwp.github.com/dotfiles/)
*	[astrails](https://github.com/astrails/dotvim)
*	[tpope](https://github.com/tpope)
*	[scrooloose](https://github.com/scrooloose)
*	[shougo](https://github.com/Shougo)
*	[lokaltog](https://github.com/Lokaltog)
*	[sjl](https://github.com/sjl)
*	[terryma](https://github.com/terryma)

## License

[WTFPL](http://sam.zoy.org/wtfpl/)

[ycm]: https://github.com/Valloric/YouCompleteMe
[us]: https://github.com/SirVer/ultisnips
[nc]: https://github.com/Shougo/neocomplete.vim
[ncl]: https://github.com/Shougo/neocomplcache.vim
[ns]: https://github.com/Shougo/neosnippet.vim
