"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Global
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible              " be iMproved, required
filetype off                  " required

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vundle
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Add all your plugins here
Plugin 'xolox/vim-misc'
"Plugin 'xolox/vim-session'
Plugin 'tpope/vim-surround'
"Plugin 'scrooloose/syntastic'
Plugin 'w0rp/ale'
Plugin 'xml.vim'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'jnurmine/Zenburn'
" Plugin 'Shougo/neocomplete.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'sjl/gundo.vim.git'
Plugin 'matchit.zip'
Plugin 'tpope/vim-commentary'
Plugin 'easymotion/vim-easymotion'
Plugin 'vim-scripts/argtextobj.vim'
"Plugin 'davidhalter/jedi-vim'
Plugin 'ervandew/supertab'
Plugin 'mhinz/vim-signify'
Plugin 'michaeljsmith/vim-indent-object'
Plugin 'tmhedberg/SimpylFold'
Plugin 'kana/vim-textobj-user'
Plugin 'bps/vim-textobj-python'
Plugin 'mileszs/ack.vim'
Plugin 'Shougo/neoyank.vim'
Plugin 'Shougo/unite-outline'
Plugin 'Shougo/unite.vim'
"Plugin 'alfredodeza/pytest.vim'
Plugin 'diepm/vim-rest-console'
Plugin 'godlygeek/tabular'
Plugin 'vim-pandoc/vim-pandoc'
Plugin 'vim-pandoc/vim-pandoc-syntax'
Plugin 'vim-pandoc/vim-pandoc-after'
Plugin 'vimwiki/vimwiki'
Plugin 'shime/vim-livedown'
Plugin 'junegunn/goyo.vim'
Plugin 'junegunn/limelight.vim'
Plugin 'francoiscabrol/ranger.vim'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'tmux-plugins/vim-tmux-focus-events'
" Plugin 'MattesGroeger/vim-bookmarks'
Plugin 'vim-scripts/Align'
Plugin 'tpope/vim-abolish'
Plugin 'dhruvasagar/vim-table-mode'
Plugin 'thaerkh/vim-workspace'
Plugin 'tpope/vim-sleuth'
Plugin 'tpope/vim-tbone'
Plugin 'tpope/vim-afterimage'
Plugin 'lervag/vimtex'
" Plugin 'ludovicchabant/vim-gutentags'
" Plugin 'metakirby5/codi.vim'
" Plugin 'rust-lang/rust.vim'
" Plugin 'shougo/vimfiler.vim'
" Plugin 'preservim/nerdtree'
" Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'mechatroner/rainbow_csv'

" All of your Plugins must be added before the following line
call vundle#end()            " required

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Align (Plugin):
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" We don't want to use aligns keymappings at all, the command syntax is enough
function! s:RemoveConflictingAlignMaps()
    if exists("g:loaded_AlignMapsPlugin")
        AlignMapsClean
    endif
endfunction
command! -nargs=0 RemoveConflictingAlignMaps call s:RemoveConflictingAlignMaps()
silent! autocmd VimEnter * RemoveConflictingAlignMaps

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Sets how many lines of history VIM has to remember
set history=700
"
" Enable filetype plugins
filetype plugin on
filetype indent on
"
" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = " "
let g:mapleader = " "

" Fast saving
nmap <leader>w :w!<cr>

" Remap Visual Block Mode to Alt-v
" (Ctrl-v gets picked up by many terminals as copy)
nmap <leader>v <C-v>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Mouse
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Redefine mouse Middle Click behavior
set mouse=a

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc

"Always show current position
set ruler

" Height of the command bar
set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hidden

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" We usuially have a fast TTY connection, this gives us better scrolling and
" general perf
set ttyfast

" Use the older regex engine, oddly it is aparently more performant on complex
" matches (Which some plugins seem to want to use)
set regexpengine=1

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

" Use Listchars to add visiual markers for whitespace
set listchars=tab:>-,eol:¬,space:·,extends:#,precedes:>
set list

function! s:reset_colors()
    colorscheme zenburn
    hi SpecialKey term=bold ctermfg=239 guifg=#9ece9e guibg=#444444
    hi NonText term=bold ctermfg=240 gui=bold guifg=#5b605e
endfunction

call s:reset_colors()

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Always turn on line numbering
set nu

" Default to splitting behavior
set splitbelow
set splitright

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Statusline && Airline (Plugin)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Configure default statusline

" Include formatting options in the status line
" (not used, since we default to airline for our statusbar)
"
"set statusline+=[%{&fo}]
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

" Keep the statusline active at all times
set laststatus=2

" We don't need airlines whitespace plugin
let g:airline#extensions#whitespace#enabled = 0

" Explicitly enable/disable some of the plugins that we might
" care about
let g:airline#extensions#syntastic#enabled = 0
let g:airline#extensions#virtualenv#enabled = 1
let g:airline#extensions#eclim#enabled = 0
let g:airline#extensions#ycm#enabled = 0
let g:airline#extensions#ale#enabled = 1

" Tweak what Airline displays, include formatoptions after the filetype
" let g:airline_section_x = airline#util#wrap( airline#parts#filetype() . '[%{&fo}]' ,0)
let g:airline_section_x = airline#parts#filetype() . ' ' . '[%{&fo}]'
function! AirlineInit()
    let g:airline_section_x = airline#section#create(['filetype', ' [%{&fo}]'])
endfunction

autocmd User AirlineAfterInit call AirlineInit()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 79 characters
set lbr
set tw=79

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing, ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>sf z=

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" move vertically by visual line
nnoremap j gj
nnoremap k gk

" more sane normal mode transitions and
" fixes to the :W vs :w problem
map ; :
noremap ;; ;

" more agile movement between splits
" map <leader>h <C-w><C-h>
" map <leader>j <C-w><C-j>
" map <leader>k <C-w><C-k>
" map <leader>l <C-w><C-l>

nnoremap <silent> <leader>sj :exe "resize +5"<CR>
nnoremap <silent> <leader>sk :exe "resize -5"<CR>
nnoremap <silent> <leader>sl :exe "vertical resize +5"<CR>
nnoremap <silent> <leader>sh :exe "vertical resize -5"<CR>

" for overkill, we will also setup commands for the capilalized versions
cabbrev WQ wq
cabbrev Wq wq
cabbrev W w
cabbrev Q q

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-tmux-navigator (Plugin)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" let g:tmux_navigator_no_mappings = 1
"
" nnoremap <silent> <leader>h :TmuxNavigateLeft<cr>
" nnoremap <silent> <leader>j :TmuxNavigateDown<cr>
" nnoremap <silent> <leader>k :TmuxNavigateUp<cr>
" nnoremap <silent> <leader>l :TmuxNavigateRight<cr>
" nnoremap <silent> {Previous-Mapping} :TmuxNavigatePrevious<cr>

let g:tmux_navigator_disable_when_zoomed = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ranger (Plugin)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:ranger_map_keys = 0
map <leader>r :Ranger<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ranger Integration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" function! RangerChooser()
"     let temp = tempname()
"     exec 'silent !ranger --choosefiles=' . shellescape(temp) . ' ' . expand('%:h')
"     if !filereadable(temp)
"         redraw!
"         " Nothing to read.
"         return
"     endif
"     let names = readfile(temp)
"     if empty(names)
"         redraw!
"         " Nothing to open.
"         return
"     endif
"     " Edit the first item.
"     exec 'edit ' . fnameescape(names[0])
"     " Add any remaning items to the arg list/buffer list.
"     for name in names[1:]
"         exec 'argadd ' . fnameescape(name)
"     endfor
"     redraw!
" endfunction
"
" function! RangerCD()
"     let temp = tempname()
"     exec 'silent !ranger --choosedir=' . shellescape(temp) . ' ' . expand('%:h')
"     if !filereadable(temp)
"         redraw!
"         " Nothing to read.
"         return
"     endif
"     let names = readfile(temp)
"     if empty(names)
"         redraw!
"         " Nothing to open.
"         return
"     endif
"     " Edit the first item.
"     exec 'cd' . fnameescape(names[0])
"     redraw!
" endfunction
"
" command! RangerChooser :call RangerChooser()
" nnoremap <leader>r :<C-U>RangerChooser<CR>
"
" command! RangerCD :call RangerCD()
" nnoremap <leader>cd :<C-U>RangerCD<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Syntastic (Plugin)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => ALE (Plugin)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nmap <silent> ]e <Plug>(ale_previous_wrap)
nmap <silent> [e <Plug>(ale_next_wrap)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Unite (Plugin):
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" call unite#custom#profile('source/vim_bookmarks', 'context', {
"     \   'start_insert': 0,
"     \   'keep_focus': 0,
"     \   'no_quit': 0,
"     \ })

let g:unite_source_history_yank_enable = 1
" call unite#filters#matcher_default#use(['matcher_fuzzy'])
nnoremap <leader>o :<C-u>Unite -buffer-name=outline -start-insert outline<cr>
nnoremap <leader>y :<C-u>Unite -buffer-name=yank    history/yank<cr>
nnoremap <leader>e :<C-u>Unite -buffer-name=buffer  -start-insert buffer -short-source-names<cr>
" nnoremap <leader>m :<C-u>Unite -buffer-name=bookmark  vim_bookmarks<cr>

" Custom mappings for the unite buffer
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
    " Play nice with supertab
    let b:SuperTabDisabled=1
    :DisableWhitespace
    setlocal nolist
    " Enable navigation with control-j and control-k in insert mode
    " imap <buffer> <C-j>   <Plug>(unite_select_next_line)
    " imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Neocomplete (Plugin):
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
"autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
" if !exists('g:neocomplete#sources#omni#input_patterns')
"     let g:neocomplete#sources#omni#input_patterns = {}
" endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^.\t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:]*\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:]*\t]\%(\.\|->\)\|\h\w*::'
"
" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
"let g:neocomplete#sources#omni#input_patterns.perl ='\h\w*->\h\w*\|\h\w*::'

" Auto-hide the preview window
let g:neocomplete#enable_auto_close_preview = 1
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

inoremap <expr><C-g> neocomplete#undo_completion()
inoremap <expr><C-l> neocomplete#complete_common_string()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Gundo (Plugin):
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <leader>u :GundoToggle<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Signify (Plugin):
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:signify_vcs_list = [ 'svn', 'git' ]

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Jedi-vim (Plugin):
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:jedi#show_call_signatures = "2"

let g:jedi#goto_command = "<leader>pd"
let g:jedi#goto_assignments_command = "<leader>pg"
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "<leader>ps"
let g:jedi#usages_command = "<leader>pn"
let g:jedi#completions_command = ""
let g:jedi#rename_command = "<leader>pr"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Python Text Objects (Plugin):
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:textobj_python_no_default_key_mappings = 1

xmap aF <Plug>(textobj-python-function-a)
omap aF <Plug>(textobj-python-function-a)
xmap iF <Plug>(textobj-python-function-i)
omap iF <Plug>(textobj-python-function-i)

xmap aC <Plug>(textobj-python-class-a)
omap aC <Plug>(textobj-python-class-a)
xmap iC <Plug>(textobj-python-class-i)
omap iC <Plug>(textobj-python-class-i)


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM Rest Console (Plugin)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:vrc_trigger = '<leader>j'
let g:vrc_curl_opts = {
    \ '-i': '',
\}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Livedown (Plugin)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" should the browser window pop-up upon previewing
let g:livedown_open = 0

" the port on which Livedown server will run
let g:livedown_port = 8090

" the browser to use
let g:livedown_browser = "google-chrome-stable"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Pandoc (Plugin)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:pandoc#syntax#conceal#use = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vimwiki (Plugin)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vimwiki likes to re-map TAB, which collides with my tab completion
let g:vimwiki_table_mappings = 0
let g:vimwiki_ext2syntax = {'.mdwiki': 'markdown'}

let g:vimwiki_list = [{ 'path': '/home/gmennenga/vimwiki/', 'syntax': 'markdown', 'ext': '.mdwiki' }]

:nmap <Leader>wl <Plug>VimwikiUISelect


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Goyo (Plugin)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:goyo_enter()
  set nolist
  Limelight
endfunction

function! s:goyo_leave()
  Limelight!
  call s:reset_colors()
  set list
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

nmap <leader>f :Goyo<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Limelight (Plugin)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color name (:help cterm-colors) or ANSI code
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_priority = -1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Sessions.vim (Plugin)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:session_autosave_periodic = 5
" let g:session_command_aliases = 1
" let g:session_autosave = 'yes'
" let g:session_autoload = 'no'
" set sessionoptions-=options
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-workspace (Plugin)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <leader>ws :ToggleWorkspace<CR>

let g:workspace_autosave_ignore = ['nerdtree']

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimtex (Plugin)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:vimtex_compiler_enabled = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NERDTree (Plugin)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nmap <leader>n :NERDTreeFind<CR>

autocmd vimleave * NERDTreeClose

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Autogroups
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd FileType * set formatoptions-=t
autocmd FileType xml setlocal shiftwidth=2 tabstop=2
autocmd FileType xsd setlocal shiftwidth=2 tabstop=2
