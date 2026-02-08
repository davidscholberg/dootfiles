" Disable intro message
set shortmess+=I

" Enable filetype detection, and plugin/indent scripts to be loaded
filetype indent plugin on
packadd comment

" Map leader to space
let mapleader = " "

" Netrwwwwwwwwww
nnoremap <leader>e :Explore<CR>

" General keybindings
nnoremap <leader>a ggVG
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>/ :nohlsearch<CR>
nnoremap <leader>` :b#<CR>
inoremap <C-c> <Esc>

" Scroll type shit
set nowrap
nnoremap <C-k> 3<C-y>
nnoremap <C-j> 3<C-e>
nnoremap <C-h> 6zh
nnoremap <C-l> 6zl
set list
set listchars=extends:>,precedes:<,tab:\ \ 
set fillchars=eob:\ 
autocmd FileType markdown,text setlocal wrap linebreak

" Window handling
nnoremap <Esc>h <C-w>h
nnoremap <Esc>j <C-w>j
nnoremap <Esc>k <C-w>k
nnoremap <Esc>l <C-w>l

" Tab handling
nnoremap <leader>z :$tab split<CR>
autocmd TabClosed * tabprevious

" Terminal settings
tnoremap <C-\> <C-\><C-n>

" Persistent terminal buffer (vibe coded this shit lmaoooooo)
let g:terminal_bufnr = -1
function! ToggleTerminal()
  if g:terminal_bufnr != -1 && bufexists(g:terminal_bufnr)
    execute 'buffer' g:terminal_bufnr
  else
    terminal ++curwin
    let g:terminal_bufnr = bufnr('%')
  endif
endfunction
nnoremap <leader>1 :call ToggleTerminal()<CR>

" Allow buffer switching when current buffer is modified
set hidden

" Confirm dialog for non-force quits
set confirm

" Search type shit
set incsearch
autocmd CmdlineEnter [/?] set hlsearch

" Line numbers
set number
set relativenumber

" Global tab and indent settings
set smartindent
set expandtab
set tabstop=4
set softtabstop=0
set shiftwidth=0
set shiftround

" Language-specific settings
autocmd FileType haskell setlocal tabstop=2

" Allow project-specific configs
set exrc
set secure

if has("termguicolors")
  set termguicolors
endif

" Why is the default colorscheme the way that it is?
colorscheme sorbet

" Statusline shiz
set laststatus=2
highlight StatusLine cterm=bold ctermfg=White ctermbg=DarkGrey gui=bold guifg=#D7DAE1 guibg=#2C2E33
highlight StatusLineNC cterm=NONE ctermfg=Grey ctermbg=DarkGrey gui=NONE guifg=#9090A0 guibg=#2C2E33
