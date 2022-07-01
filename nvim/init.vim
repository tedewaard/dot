set showmatch               " show matching 
set ignorecase              " case insensitive 
set smartcase               " Only works with ignorecase on; if use upper case then will search specifically for upper case
set nohlsearch              " highlight search 
set incsearch               " incremental search
set guicursor=              " Insert cursor is block
set tabstop=4               " number of columns occupied by a tab 
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set ruler		            " Display current line/column in status line
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set relativenumber 	        " Relative number to line you're on
set nu                      " Shows current line number you are on
syntax on                   " syntax highlighting
set mouse=a                 " enable mouse click
set clipboard=unnamedplus   " using system clipboard
"set cursorline             " highlight current cursorline
set wildmode=longest, list  " get bash-like tab completions
set scrolloff=8             " Helps keep cursor in middle of screen
set signcolumn=yes          " Adds extra column to left
set colorcolumn=80          " Adds bar to right at 80 characters
set cmdheight=2             " Give more space for displaying messages
set hidden
set nowrap
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile


"Set leader
let mapleader = " "

"Reload init.vim without leaving nvim
nnoremap <Leader>r :source $MYVIMRC<CR>


call plug#begin()

"Going to try using built in LSP based on TJDevries video with bash bunni
"Plug 'neoclide/coc.nvim', {'branch': 'release'}

"Helps with talkin to lsp servers
Plug 'neovim/nvim-lspconfig'



"Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

"Color scheme
Plug 'gruvbox-community/gruvbox'

Plug 'vim-airline/vim-airline'


call plug#end()

"Below runs in lua. It allos use of telescope-fsf-native
"lua << EOF
"EOF

"Load Lua modules
lua require("tele")


"Colorscheme gruvbox
colorscheme gruvbox
