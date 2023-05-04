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

    let g:python3_host_prog = exepath('python')
    let g:python_host_prog = exepath('python')
endif

if empty(glob(g:autoload_plugvim))
    execute "!curl -fLo " . g:autoload_plugvim . " --create-dirs " .
                \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    autocmd VimEnter * PlugInstall | source $MYVIMRC
    " Note: in window you might need to create a folder vimfiles/plugged
    " manually
endif

" check if the plugin is loaded with an assumption that you use the vimplug
" to install the plugins.
function! PlugLoaded(name)
    return has_key(g:plugs, a:name)
endfunction

"" lightline
function! SetupLightline(info)
let g:lightline = {
    \ 'colorscheme': 'default',
    \ 'active': {
    \     'left': [
    \         [ 'mode', 'paste' ],
    \         [ 'filename', 'readonly', 'modified', 'gitbranch' ]
    \     ]
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
                \ g:bufferline_status_info.after ]
endfunction
endfunction

call plug#begin(g:plug_dir)
" theme
Plug 'vim-scripts/Zenburn'
" mode line
Plug 'itchyny/lightline.vim', { 'do': ':SetupLightline' }
" display the buffer name on top of the screen
Plug 'ap/vim-buftabline'
" create an undo tree for each buffer
Plug 'mbbill/undotree'
" clean the whitespace and highlight the trailing whitespace
Plug 'ntpeters/vim-better-whitespace'
Plug 'Yggdroot/indentLine'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'dense-analysis/ale'
" Plug 'mtth/scratch.vim' " removed. not quite useful
Plug 'Gullumluvl/vim-Condor'
if v:version >= 800
    " Plug 'scrooloose/syntastic'   " check syntactical errors
    Plug 'itchyny/vim-gitbranch'  " put the branch name on the command bar
    Plug 'vim-scripts/indentpython.vim' " indent in python
    Plug 'scrooloose/nerdtree'     " display file tree
    Plug 'miyakogi/conoline.vim'   " highlight the line of cursor
    Plug 'xolox/vim-misc'         " prereq of vim-session

    let g:session_directory = expand("~/.vim_data/sessions")
    call mkdir(g:session_directory, "p", 0700)

    Plug 'xolox/vim-session'      " save and restore vim sessions
    " Plug 'scrooloose/nerdcommenter'
endif

if has('nvim') || (v:version >= 800)
    Plug 'https://gitlab.com/yorickpeterse/nvim-window.git'
    " Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    " Plug 'zchee/deoplete-clang'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
    Plug 'nvim-telescope/telescope-live-grep-args.nvim'
    Plug 'folke/todo-comments.nvim'
    " Plug 'terrortylor/nvim-comment'
    Plug 'numToStr/Comment.nvim'
else
    " Plug 'ajh17/VimCompletesMe'
endif

Plug 'tmhedberg/SimpylFold'   " fold in python
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'easymotion/vim-easymotion'
" - remove leap because it is similar to to the easymotion.
" Plug 'ggandor/leap.nvim'
" Plug 'sakshamgupta05/vim-todo-highlight'
Plug 'qpkorr/vim-bufkill'
Plug 'kassio/neoterm'
Plug 'folke/which-key.nvim'
Plug 'mhinz/vim-startify'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'p00f/nvim-ts-rainbow'
" Plug 'vhda/verilog_systemverilog.vim'
Plug 'lilydjwg/colorizer'

Plug 'nachumk/systemverilog.vim'
runtime macros/matchit.vim
au BufNewFile,BufRead *.sv,*.svh,*.vh,*.v set filetype=systemverilog
"" Plug 'luochen1990/rainbow'
"" let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle

Plug 'mileszs/ack.vim'
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

" Plug 'whonore/Coqtail'
Plug 'github/copilot.vim'

Plug 'neovim/nvim-lspconfig'
" Plug 'hrsh7th/cmp-nvim-lsp'
" Plug 'hrsh7th/cmp-buffer'
" Plug 'hrsh7th/cmp-path'
" Plug 'hrsh7th/cmp-cmdline'
" Plug 'hrsh7th/nvim-cmp'
Plug 'ms-jpq/coq_nvim'
call plug#end()


au BufNewFile,BufRead *.con set syntax=Condor
"----------------------------------------------------------------------
" GUI
"" set zenburn color scheme
let g:zenburn_force_dark_Background = 0
colorscheme zenburn


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
" do not use the insert mode to solve the problem that when pasting the text
" from the system clipboard, vim cannot recognize ESC.
set noinsertmode


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
" key mapping
nnoremap <SPACE> <Nop>
let mapleader=" "

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

function! MyCodingStyle ()
    " each tab has 2_spaces equivalent width
    execute "set tabstop=".g:indent_width
    " number of spaces in tab when editing
    execute "set softtabstop=".g:indent_width
    " Indentation width when using >> and << re-indentation
    execute "set shiftwidth=".g:indent_width
    " make sure that the tabs are expanded.
    set expandtab
    " wrap/truncate text to be within 80 character long.
    " select the text and type gq
    set textwidth=80
    set wrapmargin=2

    " in makefiles, don't expand tabs to spaces, since actual tab
    " characters are needed, and have indentation at 8 chars to be sure
    " that all indents are tabs (despite the mappings later):
    autocmd FileType make set noexpandtab shiftwidth=4 softtabstop=0
    set cino+=(0,W4
endfunction
call MyCodingStyle()

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

set nobackup         " Cancel the backup files

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
    autocmd BufNewFile,BufRead *.v,*.vs,*.pyv set filetype=verilog
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
nnoremap <Leader>n :NERDTreeToggle<Enter>
"" https://medium.com/@victormours/a-better-nerdtree-setup-3d3921abc0b9
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1

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
let g:deoplete#enable_at_startup = 0
filetype plugin indent on
syntax enable

"" set tab and s-tab to choose the autocomplete word options
inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <silent><expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

" Sessions: save vim sessions
let g:session_autosave='no'
let g:session_autoload='no'

" Buftabline: display a list of buffers on the tab line
" set hidden
nnoremap <C-l> :bnext<CR>
nnoremap <C-h> :bprev<CR>
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

" todo-commments.nvim
function! SetupTodoComment()
if !has("nvim")
    return
endif
lua << EOF
require("todo-comments").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    signs = true, -- show icons in the signs column
    sign_priority = 8, -- sign priority
    -- keywords recognized as todo comments
    keywords = {
        FIX = {
            icon = " ", -- icon used for the sign, and in search results
            color = "#FE1100", -- can be a hex color, or a named color (see below)
            alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
            -- signs = false, -- configure signs for some keywords individually
        },
        TODO = { icon = " ", color = "#F27FA5" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        },
    merge_keywords = true, -- when true, custom keywords will be merged with the defaults
    -- highlighting of the line containing the todo comment
    -- * before: highlights before the keyword (typically comment characters)
    -- * keyword: highlights of the keyword
    -- * after: highlights after the keyword (todo text)
    highlight = {
        before = "bg", -- "fg" or "bg" or empty
        keyword = "wide", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
        after = "bg", -- "fg" or "bg" or empty
        pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
        comments_only = true, -- uses treesitter to match keywords in comments only
        max_line_len = 400, -- ignore lines longer than this
        exclude = {}, -- list of file types to exclude highlighting
        },
    -- list of named colors where we try to extract the guifg from the
    -- list of hilight groups or use the hex color if hl not found as a fallback
    colors = {
        error = { "LspDiagnosticsDefaultError", "ErrorMsg", "#DC2626" },
        warning = { "LspDiagnosticsDefaultWarning", "WarningMsg", "#FBBF24" },
        info = { "LspDiagnosticsDefaultInformation", "#2563EB" },
        hint = { "LspDiagnosticsDefaultHint", "#10B981" },
        default = { "Identifier", "#7C3AED" },
        },
    search = {
        command = "rg",
        args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            },
        -- regex that will be used to match keywords.
        -- don't replace the (KEYWORDS) placeholder
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
        -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
        },
}
EOF
" TODO:
" HACK:
" BUG:
" WARN:
" FIX:
" FIXME:
" NOTE:
" INFO:
" PERF:
endfunction

call SetupTodoComment()

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
"" nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
"
if has("nvim")
lua << EOF
require("which-key").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    key_labels = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        -- For example:
        ["<space>"] = "SPC",
        ["<cr>"] = "RET",
        ["<tab>"] = "TAB",
    },-- refer to the configuration section below
}

local wk = require("which-key")
wk.register(
    {
        f = {
            -- optional group name
            name = "file",
            -- create a binding with label
            -- f = { "<cmd>Telescope find_files<cr>", "Find File" },
        },
    },
    {
        prefix = "<leader>"
    }
)
EOF
endif

hi BlackOnLightYellow guifg=#000000 guibg=#f2de91
hi Red guifg=#af0000 guibg=#f2de91
if has("nvim")
"" nvim-window
map <silent> <leader>w :lua require('nvim-window').pick()<CR>
lua << EOF
require('nvim-window').setup({
    -- The characters available for hinting windows.
    chars = {
        'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l',
        'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'
    },

    -- A group to use for overwriting the Normal highlight group in the floating
    -- window. This can be used to change the background color.
    -- normal_hl = 'Normal',
    normal_hl = 'BlackOnLightYellow',

    -- The highlight group to apply to the line that contains the hint characters.
    -- This is used to make them stand out more.
    hint_hl = 'Red',

    -- The border style to use for the floating window.
    border = 'single',
    float_height = 6,
    float_width = 12
})
EOF
endif

function! SetupTreesitter()
if !has("nvim")
    return
endif
lua << EOF
    require("nvim-treesitter.configs").setup {
        -- example
        -- https://github.com/ahmed-rezk-dev/super-nvim/blob/main/lua/treesitter-nvim.lua
        -- One of "all", "maintained" (parsers with maintainers), or a list of languages
        ensure_installed = {
            "bash",
            "c",
            "comment",
            "go",
            "lua",
            "vim",
        },

        -- Install languages synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- List of parsers to ignore installing
        ignore_install = { "javascript" },
        highlight = {
        -- ...
        },
        -- ...
        rainbow = {
            enable = true,
            -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
            extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
            max_file_lines = nil, -- Do not enable for files with more than n lines, int
            -- colors = {}, -- table of hex strings
            -- termcolors = {} -- table of colour name strings
        }
    }
EOF
endfunction

call SetupTreesitter()

"" telescope
" open files and search for text in a project
function! SetupTelescope()
if !PlugLoaded('telescope.nvim')
    echom "telescope.nvim is not loaded"
    return
endif
if !has("nvim")
    return
endif
"" lua << EOF must not be indented.
lua << EOF
    -- should find a better place to put this
    require("telescope").setup {
        defaults = {
            path_display = { 'smart' }, -- only shows the file names in the result window
        },
        extensions = {
            live_grep_args = {
            },
        },
        pickers = {
            find_files = {
                follow = true,
                -- -I show the result that normally will be ignored due to
                -- the settings in .gitignore and .fdignore
                find_command = {
                    "fd", "-I",
                },
            },
        },
    }

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
    vim.keymap.set('n', '<leader>ls', builtin.buffers, {})
    vim.keymap.set('n', '<leader>gs', builtin.grep_string, {})

    local telescope = require('telescope')
    vim.keymap.set('n', '<leader>lg', telescope.extensions.live_grep_args.live_grep_args, {})
EOF
endfunction

call SetupTelescope()

"" stop vim to render symbols and equations in tex.
let g:tex_conceal = ""

"
function! SetupCmp()
if !PlugLoaded('nvim-cmp')
    echom "nvim-cmp is not loaded"
    return
endif
set completeopt=menu,menuone,noselect,noinsert
if !has("nvim")
    return
endif
lua <<EOF
  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig').gopls.setup {
    capabilities = capabilities
  }
EOF
endfunction " SetupCmp

" call SetupCmp()

function! SetupComment()
if !PlugLoaded('nvim_comment')
    echom "nvim-cmp is not loaded"
    return
endif
set completeopt=menu,menuone,noselect
if !has("nvim")
    return
endif

lua <<EOF
    require("nvim_comment").setup({
        -- Linters prefer comment and line to have a space in between markers
        marker_padding = true,
        -- should comment out empty or whitespace only lines
        comment_empty = true,
        -- trim empty comment whitespace
        comment_empty_trim_whitespace = true,
        -- Should key mappings be created
        create_mappings = true,
        -- Normal mode mapping left hand side
        line_mapping = "gcc",
        -- Visual/Operator mapping left hand side
        operator_mapping = "gc",
        -- text object mapping, comment chunk,,
        comment_chunk_text_object = "<leader>co",
        -- Hook function to call before commenting takes place
        hook = function()
            if vim.api.nvim_buf_get_option(0, "filetype") == "verilog" then
                vim.api.nvim_buf_set_option(0, "commentstring", "// %s")
            end
            if vim.api.nvim_buf_get_option(0, "filetype") == "Condor" then
                vim.api.nvim_buf_set_option(0, "commentstring", "# %s")
            end
            if vim.api.nvim_buf_get_option(0, "filetype") == "asm" then
                vim.api.nvim_buf_set_option(0, "commentstring", "// %s")
            end
        end,
    })
EOF
endfunction " SetupPlugins

" call SetupComment()
lua require('Comment').setup()
"----------------------------------------------------------------------
" - use s{c1}{c2}
" lua require('leap').add_default_mappings()

"----------------------------------------------------------------------
lua<<EOF
vim.g.coq_settings = {
    auto_start = 'shut-up',
    keymap = {
        recommended = false,
        jump_to_mark = "<C-,>"
    },
}
EOF

set completeopt=menu,menuone,noselect,noinsert
" tab to go to the next element
ino <silent><expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
" shift-tab to go to the previous element
ino <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<BS>"
" enter to select the element
ino <silent><expr> <CR>    pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"

" Reference
" https://dougblack.io/words/a-good-vimrc.html til folding
