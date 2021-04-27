"" Use gVim settings
set nocompatible   " Use gVim defaults

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
Plug 'itchyny/lightline.vim'
Plug 'ap/vim-buftabline'        " display the buffer name on top of the screen
Plug 'mbbill/undotree'
Plug 'ntpeters/vim-better-whitespace'
Plug 'Yggdroot/indentLine'
" Plug 'ctrlpvim/ctrlp.vim'

if v:version >= 800
    Plug 'scrooloose/syntastic'   " check syntactical errors
    Plug 'itchyny/vim-gitbranch'  " put the branch name on the command bar
    Plug 'vim-scripts/indentpython.vim' " indent in python
    Plug 'scrooloose/nerdtree'     " display file tree
    Plug 'miyakogi/conoline.vim'   " highlight the line of cursor
    Plug 'xolox/vim-misc'         " prereq of vim-session
    Plug 'xolox/vim-session'      " save and restore vim sessions
    Plug 'scrooloose/nerdcommenter'
endif

if has('nvim-0.3')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
elseif has('nvim') || (v:version >= 800)
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    "Plug 'zchee/deoplete-clang'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
else
    Plug 'ajh17/VimCompletesMe'
endif

Plug 'tmhedberg/SimpylFold'   " fold in python
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'easymotion/vim-easymotion'
Plug 'sakshamgupta05/vim-todo-highlight'
Plug 'qpkorr/vim-bufkill'
Plug 'kassio/neoterm'
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
Plug 'mhinz/vim-startify'
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
    return [ g:bufferline_status_info.before,
                \ g:bufferline_status_info.current,
                \ g:bufferline_status_info.after]
endfunction

"" set the default font and font size
" set guifont=Dejavu\ Sans\ Mono:h12
set guifont=JetBrains\ Mono:h14

" enable syntax highlighting
set colorcolumn=80
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
"  set guioptions -= m  " remove Menu bar
"  set guioptions -= T  " remove Tool bar
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

" Set the status line options. Make it show more information.
set laststatus=2     " Display the status line

"----------------------------------------------------------------------
" code representation
"" folding
set foldmethod=syntax

"" enable code folding for shell scripts
au FileType sh let g:is_bash=1
au FileType sh let g:sh_fold_enabled=5
set foldenable

"----------------------------------------------------------------------
" Edit
"" all backspacing over everything in insert mode
set backspace=indent,eol,start
set wildmenu            " visual autocomplete for command menu
set wildmode=longest:full,full
set encoding=utf-8      " The encoding displayed.
set fileencoding=utf-8  " The encoding written to file.
set termencoding=utf-8
set ffs=unix,dos,mac
" intelligent comments
set comments=sl:/*,mb:\ *,elx:\ */

" a function to trim whitespace to use it like:
"" commented out because vim-better-whitespace is installed, so please
"" :call StripWhitespace instead.
" :call TrimWhitespace()
" function! TrimWhitespace()
"     let l:save = winsaveview()
"     keeppatterns %s/\s\+$//e
"     call winrestview(l:save)
" endfun

" yank to clipboard
if has("clipboard")
    set clipboard=unnamed " copy to the system clipboard

    if has("unnamedplus") " X11 support
        set clipboard+=unnamedplus
    endif
endif

"----------------------------------------------------------------------
" Indentation
"" Attempt to determine the type of a file based on its name and possibly its
"" contents. Use this to allow intelligent auto-indenting for each filetype,
"" and for plugins that are filetype specific.
filetype on
filetype plugin on
filetype indent on

" in makefiles, don't expand tabs to spaces, since actual tab characters are
" needed, and have indentation at 8 chars to be sure that all indents are tabs
" (despite the mappings later):
autocmd FileType make set noexpandtab shiftwidth=4 softtabstop=0

set autoindent
""" once the setup is done, please type :retab to convert the existing files
""" to the new settings.
set expandtab 		   " Tabs are expanded to spaces
set smarttab

set ai               " Auto indent
set si               " Smart indent

set backspace=2      " Allow backspacing over everything in insert mode
set cino+=(0,W4      " Change the indentation of the function arguments
" a_long_line(
"     argument,
"     argument);

" Formatting the C/C++ code
map <F7> gg=G<C-o><C-o>

""" show the tab with >······
set list
set listchars=tab:>·
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
""" highlight the tabs
" match Error /\t

let g:indent_width=4

function! CodingStyleMine ()
    " each tab has 2_spaces equivalent width
    execute "set tabstop=".g:indent_width
    " number of spaces in tab when editing
    execute "set softtabstop=".g:indent_width
    " Indentation width when using >> and << re-indentation
    execute "set shiftwidth=".g:indent_width
    " make sure that the tabs are expanded.
    set expandtab
    set textwidth=80
    set wrapmargin=2

    " in makefiles, don't expand tabs to spaces, since actual tab
    " characters are needed, and have indentation at 8 chars to be sure
    " that all indents are tabs (despite the mappings later):
    autocmd FileType make set noexpandtab shiftwidth=4 softtabstop=0
    set cino+=(0,W4
endfunction
call CodingStyleMine()

function! CodingStyleCompany ()
    set tabstop=3        " each tab has 2_spaces equivalent width
    set softtabstop=3    " number of spaces in tab when editing
    set shiftwidth=3     " Indentation width when using >> and << re-indentation
    set textwidth=80
endfunction

"----------------------------------------------------------------------
" Search
"" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase
set incsearch        " search as characters are entered
set hlsearch         " Enable search highlight
set wrapscan         " when searching till the end, wrap around to the beginning
set magic            " can search with a special character

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.

set vb
set noerrorbells
set novisualbell
set showcmd         " display incomplete commands
if has('mouse')
    set mouse=r
endif
set nobackup         " Cancel the backup files
set nowb
set noswapfile
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

"----------------------------------------------------------------------
if has('nvim')
    set diffopt+=iwhite
endif

"----------------------------------------------------------------------
" buffer/window management
"" to define a command, a new command must start with an upper letter
command! Bc bp\|bd \#
set splitbelow
set splitright
"----------------------------------------------------------------------
" key mapping
nnoremap <SPACE> <Nop>
let mapleader=" "
" map <SPACE> <Leader>

"" press jk to escape from the insert mode
inoremap jk <Esc>
"" mapping delay
set timeoutlen=1000
set ttimeoutlen=50

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

"" terminal mode
" mitigate the problem when switching the buffer and the terminal disappears
if has('nvim')
    autocmd TermOpen * set bufhidden=hide
endif

"----------------------------------------------------------------------
" package related setup
"----------------------------------------------------------------------
" SimpylFold: folding the python code
let g:SimpylFold_docstring_preview=1

" NerdTree: Display your file system as a tree, enabling you to easily explore
" and open various files and directories.
" map <<Leader>-d> :NERDTreeToggle<CR>
nnoremap <Leader>f :NERDTreeToggle<Enter>
"" https://medium.com/@victormours/a-better-nerdtree-setup-3d3921abc0b9
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let NERDTreeShowHidden=1

" NerdCommenter: Easily toggle the comment status of various amounts of code
" based on your key mappings.
" http://spf13.com/post/vim-plugins-nerd-commenter/

" Snipmate: Glide through often-typed code, or snippets, that you can quickly
" insert into your file. Update variables as you type.

" Syntastic: Check your syntax and be notified about errors before compiling
" your code or executing your script.
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" let g:syntastic_quiet_messages = { "type": "style" }
" let g:syntastic_debug=1
" let g:syntastic_python_checkers = ['flake8']
" let g:syntastic_python_flake8_args='--ignore=E501,E402,E302'
let g:syntastic_python_checkers = ['pylint']
let g:syntastic_python_pylint_args='-d C0111,C0103,C0413'

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

" if the g:loaded_python3_provider is set to 1, it would cancel the python3
" path that we set in the g:python3_host_prog.
" let g:loaded_python3_provider=1
" let g:python_host_prog = '/usr/local/bin/python'
"let g:python3_host_prog=system('which python3')
"let g:python3_host_prog = '/user/local/anaconda3/bin/python3'
"echo g:python3_host_prog

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
" always show the buftabline
let g:buftabline_show=2
" show the tab number which corresponds with the buffer number in vim
let g:buftabline_numbers=1
let g:buftabline_indicators=1
let g:buftabline_separators=1

" Vim-better-whitespace: highlight extra whitespace and clean those up
":EnableWhitespace
":DisableWhitespace
":ToggleWhitespace
":StripWhitespace
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:strip_only_modified_lines=0
let g:strip_whitespace_confirm=0

" Vim-easymotion: jump to anywhere in the buffers
" <Leader>c{char}{char} to move to {char}{char}
nmap <Leader>jc <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>jl <Plug>(easymotion-bd-jk)
nmap <Leader>jl <Plug>(easymotion-overwin-line)

" indentLine: display vertical lines at each indentation level
let g:indentLine_enabled = 1
let g:indentLine_char = '│'
let g:indentLine_setColors = 1
let g:indentLine_color_term = 243
" let g:indentLine_bgcolor_term = '#3a3a3a'
" let g:indentLine_color_dark = 1 " (default: 2)

" vim-todo-highlight
" it works only to add more keywords
let g:todo_highlight_config = {
            \   'BUG': {},
            \   'REVIEW': {},
            \   'NB': {},
            \   'NOTE': {
            \     'gui_fg_color': '#ffffff',
            \     'gui_bg_color': '#ffbd2a',
            \     'cterm_fg_color': 'red',
            \     'cterm_bg_color': '214'
            \   }
            \ }
" TODO: NOTE: FIXME: NB: BUG:

"" ctrlp vim
" Ctrl-P: Find full paths to files, buffers, and tags. Open multiple files at
" once and create new files or directories.
" fuzzy find files
let g:ctrlp_map = '<Leader>p'
let g:ctrlp_cmd = 'CtrlP'

let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
            \ 'dir':  '\v[\/]\.(git|hg|svn)$',
            \ 'file': '\v\.(exe|so|dll)$',
            \ }
"  \ 'link': 'some_bad_symbolic_links',

if g:os == "Windows"
    set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe         " Windows
    let g:ctrlp_user_command = 'dir %s /-n /b /s /a-d'  " Windows
endif

if g:os == "Darwin" || g:os == "Linux"
    set wildignore+=*/tmp/*,*.so,*.swp,*.zip       " MacOSX/Linux
    let g:ctrlp_user_command = 'find %s -type f'   " MacOSX/Linux
endif

"" http://andrewradev.com/2011/08/06/making-vim-pretty-with-custom-colors/
"" I have to move the customized color here; otherwise, it doesn't work.
"" change the highlight color of the current replaced text
hi IncSearch cterm=bold,underline ctermfg=green ctermbg=none
hi Search cterm=underline ctermfg=blue ctermbg=none

"" whichkey will start when the leader key is pressed.
"" in this case we assume that space is the leader key.
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

" Reference
" https://dougblack.io/words/a-good-vimrc.html til folding
