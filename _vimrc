" Use gVim settings
set nocompatible 	   " Use gVim defaults

" GUI
"" set zenburn color scheme
let g:zenburn_force_dark_Background = 1
colorscheme zenburn

"" set the default font and font size
set guifont=Dejavu\ Sans\ Mono:h12

set number           " enable line number
set ruler            " Show the line and column number (cursor position)
set showmatch        " highlight matching [{()}]
syntax on            " set syntax highlight 
set showcmd          " show incomplete command in bottom bar
set lazyredraw       " redraw only when we need to.
set modeline
set modelines=1

" Edit
"" all backspacing over everything in insert mode
set backspace=indent,eol,start

" Indentation
"" Attempt to determine the type of a file based on its name and possibly its
"" contents. Use this to allow intelligent auto-indenting for each filetype,
"" and for plugins that are filetype specific.
filetype plugin indent on

set autoindent
set backspace=2 	   " Allow backspacing over everything in insert mode
set tabstop=2        " each tab has 2_spaces equivalent width
set shiftwidth=2     " Indentation width when using >> and << re-indentation
set expandtab 		   " Tabs are expanded to spaces

" Search
"" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase
set incsearch        " search as characters are entered
set hlsearch         " Enable search highlight
set wrapscan         " when searching till the end, wrap around to the beginning

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.

set vb
set viminfo+=n$VIM/_viminfo
set noerrorbells
set showcmd         " display incomplete commands
if has('mouse')
   set mouse=a
endif   
set history=1000
set undolevels=1000

set nobackup         " Cancel the backup files


" this line below is specific to MS Windows machines and should be removed 
" for other systems
behave mswin

"Set the status line options. Make it show more information.
set laststatus=2     " Display the status line
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\[POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}

"nesc syntax highlight 
augroup filetypedetect 
  au! BufRead,BufNewFile *nc setfiletype nc 
augroup END

" how to install vim-plug
" https://vi.stackexchange.com/questions/613/how-do-i-install-a-plugin-in-vim-vi
if empty(glob('~/vimfiles/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/vimfiles/plugged')
Plug 'mbbill/undotree'
call plug#end() 

" NerdTree: Display your file system as a tree, enabling you to easily explore
" and open various files and directories.

" NerdCommenter: Easily toggle the comment status of various amounts of code
" based on your key mappings.

" Snipmate: Glide through often-typed code, or snippets, that you can quickly
" insert into your file. Update variables as you type.

" Ctrl-P: Find full paths to files, buffers, and tags. Open multiple files at
" once and create new files or directories.

" Syntastic: Check your syntax and be notified about errors before compiling
" your code or executing your script.
