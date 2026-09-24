let mapleader = " "

filetype plugin indent on
syntax enable

" --- UI ---
set number
set relativenumber
set showmode
set laststatus=2
set cursorline
set scrolloff=5
set sidescrolloff=5
set signcolumn=yes
set wildmenu
if has('termguicolors')
  set termguicolors
endif

" Cursor shape per mode: block in normal, bar in insert, underline in replace
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50

" --- Search ---
set incsearch
set hlsearch
set ignorecase
set smartcase

" --- Indentation ---
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set smartindent

" --- Editing behaviour ---
set mouse=a
set hidden          " allow switching buffers without saving
set confirm         " prompt instead of failing on unsaved changes
if has('clipboard')
  set clipboard=unnamedplus
endif

" --- Persistent undo (survives closing vim) ---
if has('persistent_undo')
  let s:undodir = expand('~/.vim/undodir')
  if !isdirectory(s:undodir)
    call mkdir(s:undodir, 'p')
  endif
  set undofile
  set undodir=~/.vim/undodir
endif

" Keep swap/backup files out of project directories
set backupdir=~/.vim/backup//,.
set directory=~/.vim/swap//,.
if !isdirectory(expand('~/.vim/backup'))
  call mkdir(expand('~/.vim/backup'), 'p')
endif
if !isdirectory(expand('~/.vim/swap'))
  call mkdir(expand('~/.vim/swap'), 'p')
endif

" --- Filetype tweaks ---
augroup filetype_overrides
  autocmd!
  " Kubernetes/K3s YAML is normally 2-space indentation
  autocmd FileType yaml setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=2
augroup END

" --- Quality-of-life mappings ---
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <esc> :nohlsearch<CR>
inoremap jk <esc>
