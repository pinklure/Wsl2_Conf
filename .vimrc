set encoding=utf-8
set nu
set mouse=v
syntax on
set hlsearch
set is hls
set tabstop=2
set shiftwidth=2
" set list
set foldmethod=syntax
set nofoldenable
set foldlevel=1



" powerline
set rtp+=/usr/local/lib/python3.8/dist-packages/powerline/bindings/vim/
set laststatus=2
set t_Co=256


call plug#begin('~/.vim/plugged')

" ###INSERT模式粘贴文本###
Plug 'roxma/vim-paste-easy'

" ###注释代码###
" 快捷键 g+c+c
Plug 'tpope/vim-commentary'

" ###模糊查找文件###
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
" 选择当前项目的文件
let g:Lf_ShortcutF = '<c-p>'
" 选择历史文件
noremap <c-n> :LeaderfMru<cr>
" 选择当前buffer的函数
execute "set <m-p>=\ep"
noremap <m-p> :LeaderfFunction<cr>
" 不使用 separator
let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }
" 定位项目root
let g:Lf_RootMarkers = ['.project', '.root', '.svn','.git', 'compile_commands.json', '.clang-format']
" 模糊查找忽略文件、目录
let g:Lf_WildIgnore = {
		\ 'dir':['.git','.ccls-cache','CMakeFiles'],
		\ 'file':[]
	  \ }
" 工作目录模式
let g:Lf_WorkingDirectoryMode = 'Ac'
" Leaderf 窗口大小占比
let g:Lf_WindowHeight = 0.30
" Leaderf Cache 目录
let g:Lf_CacheDirectory = expand('~/.vim/cache')
" 不使用相对路径，使用基于项目根目录的路径
let g:Lf_ShowRelativePath = 0
" 禁用 F1 显示帮助页面
let g:Lf_HideHelp = 1
" 主体使用 powerline
let g:Lf_StlColorscheme = 'powerline'

" ###异步执行###
Plug 'skywind3000/asyncrun.vim'

" 自动打开 quickfix window ，高度为 8
let g:asyncrun_open = 8
" 任务结束时候响铃提醒
let g:asyncrun_bell = 1
" 设置 F10 打开/关闭 Quickfix 窗口，但是不能在Quickfix内进行滚动，弃用
" nnoremap <F10> :call asyncrun#quickfix_toggle(8)<cr>
" 打开关闭Quickfix窗口，且能在其中浏览
nnoremap <F9> :cclose <cr>
nnoremap <F10> :copen <cr>
" 在当前目录执行shell命令
nnoremap <F11> :AsyncRun 
" 在项目根目录执行shell命令
nnoremap <F12> :AsyncRun -cwd=<root> 
" 定位项目root
let g:asyncrun_rootmarks = ['.svn', '.git', '.root', 'compile_commands.json', 'clang-format']

" ###自动运行 ctags，辅助language server查找变量###
Plug 'ludovicchabant/vim-gutentags'
" gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
let g:gutentags_project_root = ['.git', 'clang-format', '.ccls', 'compile_commands.json', '.root']
" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = '.tags'
" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags
" 配置 ctags 的参数
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
" 检测 ~/.cache/tags 不存在就新建
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
endif

" ###clang-format###
Plug 'rhysd/vim-clang-format'
" 选择风格
let g:clang_format#code_style = 'google'
" 自动检测 .clang-format 文件
let g:clang_format#detect_style_file = 1
" 检测文件类型
let g:clang_format#auto_filetypes = ["c", "cc", "h", "proto"]
" F7格式化代码
nnoremap <F7> :ClangFormat<cr>

Plug 'yuratomo/w3m.vim'

" ###Coc.Nvim###
Plug 'neoclide/coc.nvim', {'branch':'release'}

call plug#end()



" 以下是Coc.Nvim的配置
set hidden
set nobackup
set nowritebackup
set cmdheight=1
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>


