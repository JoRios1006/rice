let g:neovide_scale_factor = 0.6
let g:neovide_padding_top = 0
let g:neovide_padding_bottom = 0
let g:neovide_padding_right = 0
let g:neovide_padding_left = 0
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
let maplocalleader = "\,"
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - For Vim: ~/.vim/plugged
"
call plug#begin('~/.local/share/nvim/plugged')

" List of plugins
Plug 'elixir-editors/vim-elixir'
Plug 'mattreduce/vim-mix'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'windwp/nvim-ts-autotag'
Plug 'p00f/nvim-ts-rainbow'
Plug 'prettier/vim-prettier'
Plug 'jiangmiao/auto-pairs'
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'williamboman/nvim-lsp-installer'
Plug 'jceb/vim-orgmode'
Plug 'vim-scripts/utl.vim'
Plug 'tpope/vim-repeat'
Plug 'vim-scripts/taglist.vim'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-speeddating'
Plug 'chrisbra/NrrwRgn'
Plug 'mattn/calendar-vim'
Plug 'vim-scripts/SyntaxRange'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'itchyny/lightline.vim'
Plug 'justinmk/vim-sneak'
Plug 'easymotion/vim-easymotion'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'jiangmiao/auto-pairs'
Plug 'hrsh7th/vim-vsnip'
Plug 'jpalardy/vim-slime'
Plug 'Olical/conjure'

let g:conjure#filetype#scheme = "conjure.client.guile.socket"
let g:slime_target = "tmux"
let g:slime_python_interp = "python3"

let g:LanguageClient_serverCommands = {
    \ 'julia': ['julia', '--startup-file=no', '--history-file=no', '-e', 'using LanguageServer; server = LanguageServer.LanguageServerInstance(stdin, stdout, false, "/path/to/your/julia/environment/Project.toml", "", Dict()); server.runlinter = true; run(server);']
    \ }
" Initialize plugin system
call plug#end()


" Vsnip configuration
let g:vsnip_snippet_dir = '~/.config/nvim/snippets'
imap <expr> <C-j> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>'
smap <expr> <C-j> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>'
imap <expr> <C-k> vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-k>'
smap <expr> <C-k> vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-k>'

" LSP configuration
lua << EOF
require'lspconfig'.tsserver.setup{
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = false
  end
}
EOF

lua << EOF
local lspconfig = require'lspconfig'
lspconfig.elixirls.setup{
    cmd = {"language_server.sh"}
}
EOF

lua << EOF
require'lspconfig'.julials.setup{}
EOF

" Autocomplete configuration
lua << EOF
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      require'luasnip'.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<C-y>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'luasnip' },
  },
})
EOF

" Treesitter configuration
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  highlight = {
    enable = true,
  },
  autotag = {
    enable = true,
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = 1000,
  },
}
EOF

lua << EOF
require'nvim-tree'.setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  open_on_tab         = false,
  hijack_cursor       = false,
  update_cwd          = false,
  update_focused_file = {
    enable      = false,
    update_cwd  = false,
    ignore_list = {}
  },
  system_open = {
    cmd  = nil,
    args = {}
  },
}
EOF


" Prettier configuration
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx,*.css,*.scss,*.json,*.graphql,*.md,*.vue Prettier

" GitGutter configuration
set updatetime=100

" Lightline configuration
let g:lightline = { 'colorscheme': 'wombat' }

nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeFindFile<CR>

set relativenumber
set number
set clipboard+=unnamedplus

" Save session on exit
autocmd VimLeave * mksession! ~/.config/nvim/session.vim

" Restore session on startup
autocmd VimEnter * if argc() == 0 && filereadable("~/.config/nvim/session.vim") | source ~/.config/nvim/session.vim | endif

" Command to open the config File
command! EditConfig edit $MYVIMRC

let g:python3_host_prog = '/usr/bin/python3'


nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> gf :call LanguageClient_textDocument_formatting()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
