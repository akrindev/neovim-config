" ============================================================================
" GENERAL SETTINGS
" ============================================================================
set encoding=utf-8              " Use Unicode encoding
set title                      " Set window title
set number                     " Show line numbers
set cursorline                 " Highlight current line
set ruler                      " Show cursor position
set scrolloff=5                " Keep cursor 5 lines from screen edges
set showtabline=2              " Always show tab bar
set clipboard=unnamedplus      " Use system clipboard
set mouse=a                    " Enable mouse support
set termguicolors             " Enable true color support
set hidden                     " Allow background buffers
set cmdheight=2                " Better display for messages
set updatetime=300             " Faster completion
set shortmess+=c               " Don't give completion messages
set signcolumn=yes            " Always show sign column

" Indentation settings
set autoindent                 " Auto indent new lines
set smartindent                " Smart indenting
set expandtab                  " Use spaces instead of tabs
set tabstop=4                  " Tab width
set softtabstop=4              " Soft tab width
set shiftwidth=4               " Indent width
set smarttab                   " Smart tab behavior
set colorcolumn=80             " Line length marker
set nowrap                     " Don't wrap lines

" Search settings
set ignorecase                 " Case-insensitive search
set smartcase                  " Smart case search

" Error handling
set noerrorbells               " Disable error bells
set novisualbell              " Disable visual bell

" Completion settings
set completeopt=menu,menuone,noselect

" ============================================================================
" VIM-PLUG INITIALIZATION
" ============================================================================
call plug#begin('~/.config/nvim/plugged')

" File Navigation
Plug 'scrooloose/nerdtree'            " File explorer
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'               " Fuzzy finder

" Editor Enhancement
Plug 'tpope/vim-sensible'             " Sensible defaults
Plug 'tpope/vim-surround'             " Surround text objects
Plug 'tpope/vim-commentary'           " Comment code
Plug 'tpope/vim-fugitive'             " Git integration
" Plug 'Townk/vim-autoclose'            " Auto close pairs
Plug 'terryma/vim-multiple-cursors'   " Multiple cursors
Plug 'airblade/vim-gitgutter'         " Git diff in gutter
Plug 'fisadev/FixedTaskList.vim'      " Task list

" Appearance
Plug 'vim-airline/vim-airline'        " Status line
Plug 'vim-airline/vim-airline-themes' " Airline themes
Plug 'ryanoasis/vim-devicons'         " File icons
Plug 'drewtempelmeyer/palenight.vim'  " Palenight theme
Plug 'Yggdroot/indentLine'            " Indent guides
Plug 'nathanaelkane/vim-indent-guides'

" Language Support
Plug 'sheerun/vim-polyglot'           " Language pack
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dense-analysis/ale'             " Linting
Plug 'SirVer/ultisnips'              " Snippets

" Web Development
Plug 'pangloss/vim-javascript'        " JavaScript support
Plug 'maxmellon/vim-jsx-pretty'       " JSX support
Plug 'mattn/emmet-vim'                " HTML/CSS expansion
Plug 'ap/vim-css-color'               " Color preview
Plug 'prettier/vim-prettier'          " Code formatting

" AI Autocomplete
" Plug 'Exafunction/codeium.vim', { 'branch': 'main' }
Plug 'supermaven-inc/supermaven-nvim'

call plug#end()

lua << EOF
require("supermaven-nvim").setup({
  keymaps = {
    accept_suggestion = nil, -- handled by <Tab> in CoC section
    clear_suggestion = "<C-]>",
    accept_word = "<C-j>",
  },
  ignore_filetypes = { cpp = true },
  color = {
    suggestion_color = "#ffffff",
    cterm = 244,
  },
  log_level = "info", -- "info", "warn", "error", "debug"
  disable_inline_completion = false, -- disables inline completion for use with cmp
  disable_keymaps = false, -- disables built in keymaps for more control
})
EOF

" ============================================================================
" PLUGIN CONFIGURATIONS
" ============================================================================
" NERDTree Configuration
let NERDTreeIgnore = ['\.pyc$', '\.pyo$', '__pycache__', '\.git$']
nnoremap <C-g> :NERDTreeToggle<CR>
nnoremap ,t :NERDTreeFind<CR>
let NERDTreeShowHidden=1

" Airline Configuration
let g:airline_theme = 'palenight'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" CoC Configuration
let g:coc_global_extensions = [
    \ 'coc-json',
    \ 'coc-css',
    \ 'coc-html',
    \ 'coc-tsserver',
    \ 'coc-prettier',
    \ 'coc-eslint'
    \ ]

" ============================================================================
" KEY MAPPINGS
" ============================================================================
" Leader key
let mapleader = " "

" Tab navigation (Fixed version without conflicts)
" Using Ctrl+PageUp/PageDown for all modes
nmap <C-PageDown> :tabnext<CR>
nmap <C-PageUp> :tabprevious<CR>
imap <C-PageDown> <ESC>:tabnext<CR>
imap <C-PageUp> <ESC>:tabprevious<CR>

" Alternative tab navigation with leader
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>tl :tabnext<CR>
nnoremap <leader>th :tabprevious<CR>
nnoremap <leader>tc :tabclose<CR>

" ============================================================================
" COC CONFIGURATION
" ============================================================================
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
" ============================================================================
" COC CONFIGURATION
" ============================================================================
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
            \ luaeval('require("supermaven-nvim.completion_preview").has_suggestion()') ? luaeval('require("supermaven-nvim.completion_preview").on_accept_suggestion()') . "" :
            \ coc#pum#visible() ? coc#pum#next(1) :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>"
" coc-prettier
" command! -nargs=0 Prettier :CocCommand prettier.formatFile

" CoC code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" FZF mappings
nnoremap <C-p> :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>h :History<CR>

" Clear search highlighting
nnoremap <silent> // :noh<CR>

" Save and quit shortcuts
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :q!<CR>

" Split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" ============================================================================
" THEME SETTINGS
" ============================================================================
syntax enable
set background=dark
colorscheme palenight

" Make background transparent
hi Normal guibg=NONE ctermbg=NONE
