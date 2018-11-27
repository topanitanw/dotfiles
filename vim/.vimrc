"" Use gVim settings
set nocompatible 	   " Use gVim defaults

"----------------------------------------------------------------------
" how to install vim-plug
" https://vi.stackexchange.com/questions/613/how-do-i-install-a-plugin-in-vim-vi
if !exists("g:os")
   if has("win64") || has("win32") || has("win16")
      let g:os = "Windows"
      " gvim, g:os = Windows
   else
      let g:os = substitute(system('uname'), '\n', '', '')
      " for bash window subsystem, g:os = 'Linux'
      " for mac osx, g:os = 'Darwin'
   endif
endif

if g:os == "Windows"
  if !has('nvim')
    " as of 05/24/2018 Neovim on Windows is experimental so skip it.
    let g:autoload_plugvim = 'vimfiles/autoload/plug.vim'
    let g:plug_dir = 'vimfiles/plugged'
  endif
endif

if g:os == "Darwin" || g:os == "Linux"
  "if has('nvim')
    "let g:autoload_plugvim = expand("~/.local/share/nvim/site/autoload/plug.vim")
    "let g:plug_dir = expand("~/.local/share/nvim/plugged")
    "let g:editor_root= expand("~/.config/nvim")
  "else
    let g:autoload_plugvim = expand("~/.vim/autoload/plug.vim")
    let g:plug_dir = expand("~/.vim/plugged")
    let g:editor_root = expand("~/.vim")
  "endif
endif

if empty(glob(g:autoload_plugvim))
  execute "!curl -fLo " . g:autoload_plugvim . " --create-dirs " .
    \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  autocmd VimEnter * PlugInstall | source $MYVIMRC
  " Note: in window you might need to create a folder vimfiles/plugged
  " manually
endif

call plug#begin(g:plug_dir)
Plug 'vim-scripts/Zenburn'
Plug 'mbbill/undotree'
Plug 'itchyny/lightline.vim'
" Plug 'scrooloose/syntastic'   " check syntactical errors
Plug 'itchyny/vim-gitbranch'  " put the branch name on the command bar
Plug 'tmhedberg/SimpylFold'   " fold in python
Plug 'vim-scripts/indentpython.vim' " indent in python
Plug 'scrooloose/nerdtree'     " display file tree
Plug 'miyakogi/conoline.vim'
Plug 'xolox/vim-misc'         " prereq of vim-session
Plug 'xolox/vim-session'      " save and restore vim sessions
Plug 'scrooloose/nerdcommenter'
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
endif

if !has('nvim') && (v:version >= 800)
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'ap/vim-buftabline'
call plug#end()

"----------------------------------------------------------------------
" GUI
"" set zenburn color scheme
let g:zenburn_force_dark_Background = 1
colorscheme zenburn

let g:lightline = {
      \ 'colorscheme': 'default',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'filename', 'readonly', 'modified', 'gitbranch' ] ]
      \ },
      \ 'component_function': {
      \   'filename': 'LightLineFilename',
      \   'gitbranch': 'gitbranch#name'
      \ },
      \ 'tabline': {
      \   'left': [ ['bufferline'] ]
      \ }, 
      \ 'component_expand': {
      \   'bufferline': 'LightLineBufferline',
      \ },
      \ 'component_type': {
      \   'bufferline': 'tabsel',
      \ },
      \ }

function! LightLineFilename()
  return expand('%')
endfunction

function! LightlineBufferline()
  call bufferline#refresh_status()
  return [ g:bufferline_status_info.before, g:bufferline_status_info.current, g:bufferline_status_info.after]
endfunction
"" set the default font and font size
set guifont=Dejavu\ Sans\ Mono:h12

set number              " enable line number
set ruler               " Show the line and column number (cursor position)
set cursorline          " highlight the current line
set showmatch           " highlight matching braces [{()}]
syntax on               " set syntax highlight
set showcmd             " show incomplete command in bottom bar
set lazyredraw          " redraw only when we need to.
set modeline
set modelines=1

if has("gui_running")
"  set guioptions -= m   "remove Menu bar
"  set guioptions -= T   "remove Tool bar
endif

" from here https://sunaku.github.io/vim-256color-bce.html
if g:os == "Windows"
   set term=xterm " screen-256color
elseif !has('nvim')
   set term=screen-256color
endif
set t_ut=
set t_Co=256

"" set the cursor of all modes to be a block
set guicursor=a:block

"----------------------------------------------------------------------
" code representation
"" folding
set foldmethod=syntax

"----------------------------------------------------------------------
" Edit
"" all backspacing over everything in insert mode
set backspace=indent,eol,start
set wildmenu            " visual autocomplete for command menu
set encoding=utf-8      " The encoding displayed.
set fileencoding=utf-8  " The encoding written to file.
set termencoding=utf-8
" intelligent comments
set comments=sl:/*,mb:\ *,elx:\ */
"----------------------------------------------------------------------
" Indentation
"" Attempt to determine the type of a file based on its name and possibly its
"" contents. Use this to allow intelligent auto-indenting for each filetype,
"" and for plugins that are filetype specific.
filetype plugin indent on

set autoindent
set expandtab 		   " Tabs are expanded to spaces
set backspace=2 	   " Allow backspacing over everything in insert mode
set cino+=(0         " Change the indentation of the function arguments

let g:indent_width=4
function! CodingStyleMine ()
  " each tab has 2_spaces equivalent width
  execute "set tabstop=".g:indent_width        
  " number of spaces in tab when editing
  execute "set softtabstop=".g:indent_width    
  " Indentation width when using >> and << re-indentation
  execute "set shiftwidth=".g:indent_width     
endfunction
call CodingStyleMine()

function! CodingStyleCompany ()
  set tabstop=3        " each tab has 2_spaces equivalent width
  set softtabstop=3    " number of spaces in tab when editing
  set shiftwidth=3     " Indentation width when using >> and << re-indentation
  set textwidth=79
endfunction

"----------------------------------------------------------------------
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
set noerrorbells
set showcmd         " display incomplete commands
if has('mouse')
   set mouse=r
endif
set nobackup         " Cancel the backup files
set history=1000
set undolevels=1000
set undofile         " maintain undo history between sessions

" does not create the folder in the .vim directory
" let g:undo_dir=expand("~/.vim/undo/")
" if !isdirectory()
"   execute "call mkdir(".g:undo_dir.", \"p\")"
" endif
" set undodir=g:undo_dir

" this line below is specific to MS Windows machines and should be removed
" for other systems
if g:os == "Windows"
   behave mswin
endif

"Set the status line options. Make it show more information.
set laststatus=2     " Display the status line

"----------------------------------------------------------------------
" key mapping
nnoremap <SPACE> <Nop>
let mapleader=" "

" yank to clipboard
if has("clipboard")
  set clipboard=unnamed " copy to the system clipboard

  if has("unnamedplus") " X11 support
    set clipboard+=unnamedplus
  endif
endif

"----------------------------------------------------------------------
" auto command
"----------------------------------------------------------------------
augroup filetype
  autocmd BufNewFile,BufRead *.h set filetype=c
  autocmd BufNewFile,BufRead *.mk set filetype=make
  autocmd BufNewFile,BufRead *.sc set filetype=make
  autocmd BufNewFile,BufRead *akefile.rules set filetype=make
augroup END

"----------------------------------------------------------------------
" mode related setup
"" in vim, mode (emacs) is filetype
"" setting the make mode in vim is :set filetype=make
"----------------------------------------------------------------------
" nesc syntax highlight
augroup filetypedetect
  au! BufNewFile,BufRead *.nc set filetype=nc
augroup END

" " python mode setting
" au BufNewFile,BufRead *.py
"     \ set tabstop=4
"     \ set softtabstop=4
"     \ set shiftwidth=4
"     \ set textwidth=79
"     \ set expandtab
"     \ set autoindent
"     \ set fileformat=unix
"

" in makefiles, don't expand tabs to spaces, since actual tab characters are
" needed, and have indentation at 8 chars to be sure that all indents are tabs
" (despite the mappings later):
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0
"----------------------------------------------------------------------
" package related setup
"----------------------------------------------------------------------
" SimpylFold: folding the python code
let g:SimpylFold_docstring_preview=1

" NerdTree: Display your file system as a tree, enabling you to easily explore
" and open various files and directories.
map <<leader>-n> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let NERDTreeShowHidden=1

" NerdCommenter: Easily toggle the comment status of various amounts of code
" based on your key mappings.
" http://spf13.com/post/vim-plugins-nerd-commenter/

" Snipmate: Glide through often-typed code, or snippets, that you can quickly
" insert into your file. Update variables as you type.

" Ctrl-P: Find full paths to files, buffers, and tags. Open multiple files at
" once and create new files or directories.

" Syntastic: Check your syntax and be notified about errors before compiling
" your code or executing your script.
"" load a machine specific vimrc file
if !empty(glob("~/.vimrc_machine_specific"))
  source ~/.vimrc_machine_specific
endif

" Conoline: This plugin highlights the line of the cursor, only in the current window.
let g:conoline_auto_enable = 1
"" use the color in the colorscheme
let g:conoline_use_colorscheme_default_normal=1
let g:conoline_use_colorscheme_default_insert=1

" Deoplete: Autocomplete for vim8 and neovim
let g:deoplete#enable_at_startup = 1
filetype plugin indent on
syntax enable
" let g:loaded_python3_provider=1
" let g:python_host_prog = '/usr/local/bin/python'
" let g:python3_host_prog = '/usr/local/bin/python3'

"" set tab and s-tab to choose the autocomplete word options
inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <silent><expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

" Sessions: save vim sessions 
let g:session_autosave='no'
let g:session_autoload='no'

" Buftabline: display a list of buffers on the tab line
" set hidden 
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>

" Reference
" https://dougblack.io/words/a-good-vimrc.html til folding
