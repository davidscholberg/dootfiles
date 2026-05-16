" Disable intro message
set shortmess+=I

" Enable filetype detection, and plugin/indent scripts to be loaded
filetype indent plugin on
packadd comment
syntax enable

" Map leader to space
let mapleader = " "

" Netrwwwwwwwwww
let g:netrw_altfile = 1
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_maxfilenamelen = 78
augroup netrw_config
    autocmd!
    autocmd FileType netrw setlocal nobuflisted
augroup END
nnoremap <leader>e :Explore<CR>

" General keybindings
nnoremap <leader>v ^vg_
nnoremap <leader>a ggVG
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>p "+p
vnoremap <leader>p "+p
nnoremap <leader>P "+P
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
set fillchars=eob:\ ,vert:│,diff:╱
autocmd FileType markdown,text setlocal wrap linebreak

" Window handling
nnoremap <M-h> <C-w>h
nnoremap <M-j> <C-w>j
nnoremap <M-k> <C-w>k
nnoremap <M-l> <C-w>l
nnoremap <leader>wp :pclose<CR>
set splitright
set splitbelow
autocmd FileType help,man wincmd L

" Tab handling
function! CustomTabLine() abort
    let l:tabline = ''
    for l:i in range(1, tabpagenr('$'))
        if l:i == tabpagenr()
            let l:tabline .= '%#TabLineSel#'
        else
            let l:tabline .= '%#TabLine#'
        endif
        let l:buflist = tabpagebuflist(l:i)
        let l:winnr = tabpagewinnr(l:i)
        let l:bufnr = l:buflist[l:winnr - 1]
        let l:bufname = bufname(l:bufnr)
        let l:filename = fnamemodify(l:bufname, ':t')
        if l:filename ==# ''
            let l:filename = '¯\_(ツ)_/¯'
        endif
        let l:tabline .= ' ' . l:i . ': ' . l:filename . ' '
    endfor
    let l:tabline .= '%#TabLineFill#%T'
    return l:tabline
endfunction
set tabline=%!CustomTabLine()
set tabclose=uselast
function! CloseExtraTabs() abort
    for l:i in range(tabpagenr('$'), 2, -1)
        execute 'tabclose ' . l:i
    endfor
endfunction
nnoremap <leader>wt :call CloseExtraTabs()<CR>

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
set hlsearch
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

" Put swap files in central location
set directory=~\AppData\Local\Temp,c:\tmp,c:\temp

" Allow project-specific configs
set exrc
set secure

" Statusline shiz
set statusline=%<%-2.{mode()}\ %f\ %h%w%m%r%(\ %{GetLinterStatus()}\ %)%=%-14.(%l,%c%V%)\ %P
set laststatus=2
set noshowmode

" Function for printing out syntax group stack of character under the cursor.
" Kinda the equivalent of :Inspect in neovim.
function! SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" plugin manager shiiiiiiiiiit

" minpac requires nocompatible
if &compatible
    set nocompatible
endif

packadd minpac
call minpac#init()

" ale
call minpac#add('dense-analysis/ale')
let g:ale_completion_enabled = 1
let g:ale_linters_explicit = 1
let g:ale_linters = {
            \ 'c': ['clangd'] }
let g:ale_references_use_fzf = 1
let g:ale_set_highlights = 0
let g:ale_sign_column_always = 1
let g:ale_virtualtext_cursor = 0
function! GetLinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr())
    if l:counts.total == 0
        return ''
    endif
    let l:info  = l:counts.info
    let l:warn  = l:counts.warning + l:counts.style_warning
    let l:error = l:counts.error   + l:counts.style_error
    let l:parts = []
    if l:info > 0
        call add(l:parts, 'I:' . l:info)
    endif
    if l:warn > 0
        call add(l:parts, 'W:' . l:warn)
    endif
    if l:error > 0
        call add(l:parts, 'E:' . l:error)
    endif
    return join(l:parts, ' ')
endfunction
augroup ALELSPMaps
    autocmd!
    autocmd User ALELSPStarted nnoremap K  :ALEHover<CR>
    autocmd User ALELSPStarted nnoremap gd :ALEGoToDefinition<CR>
    " can't wait for this shit to drop, gonna be epic
    " autocmd User ALELSPStarted nnoremap gD :ALEGoToDeclaration<CR>
    autocmd User ALELSPStarted nnoremap gr :ALEFindReferences<CR>
    autocmd User ALELSPStarted nnoremap gl :ALEDetail<CR>
    autocmd User ALELSPStarted nnoremap [d :ALEPreviousWrap<CR>
    autocmd User ALELSPStarted nnoremap ]d :ALENextWrap<CR>
augroup END

" fzf
call minpac#add('junegunn/fzf')
call minpac#add('junegunn/fzf.vim')
let g:fzf_vim = {}
if has("termguicolors")
    let g:fzf_force_termguicolors = 1
endif
let g:fzf_colors = {
            \ 'fg':      ['fg', 'Normal'],
            \ 'bg':      ['bg', 'Normal'],
            \ 'hl':      ['fg', 'Comment'],
            \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
            \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
            \ 'hl+':     ['fg', 'Statement'],
            \ 'info':    ['fg', 'PreProc'],
            \ 'border':  ['fg', 'Ignore'],
            \ 'prompt':  ['fg', 'Conditional'],
            \ 'pointer': ['fg', 'Exception'],
            \ 'marker':  ['fg', 'Keyword'],
            \ 'spinner': ['fg', 'Label'],
            \ 'header':  ['fg', 'Comment'] }
command! -bang -nargs=* Rg call fzf#vim#grep('rg --glob "!.git" --hidden --column --line-number --no-heading --color=always --smart-case -- '.fzf#shellescape(<q-args>), fzf#vim#with_preview(), <bang>0)
command! -bang -nargs=* RG call fzf#vim#grep2('rg --glob "!.git" --hidden --column --line-number --no-heading --color=always --smart-case -- ', <q-args>, fzf#vim#with_preview(), <bang>0)
command! -bang -nargs=? GFiles call fzf#vim#gitfiles(<q-args>, extend(fzf#vim#with_preview(<q-args> == "?" ? { "placeholder": "" } : {}), {"dir": getcwd()}), <bang>0)
nnoremap <leader>ff :GFiles<CR>
nnoremap <leader>fg :RG<CR>
nnoremap <leader>fc :BLines<CR>
nnoremap <leader>fb :Buffers<CR>

" minpac (woah so meta)
call minpac#add('k-takata/minpac', {'type': 'opt'})

" neato colorscheme
call minpac#add('davidscholberg/neato.vim')
if has("termguicolors")
    set termguicolors
endif
let g:neato_hl_func_calls = 1
colorscheme neato

" vim-fugitive
call minpac#add('tpope/vim-fugitive')
nnoremap <leader>gg :Git<CR>
nnoremap <leader>ga :Git add .<CR>
nnoremap <leader>gdd :Git difftool -y<CR>
nnoremap <leader>gdc :Git difftool -y --cached<CR>
nnoremap <leader>gps :Git push<CR>
nnoremap <leader>gpl :Git pull<CR>

" vim-sneak
call minpac#add('justinmk/vim-sneak')
let g:sneak#label = 1
