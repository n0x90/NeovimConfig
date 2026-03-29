setlocal expandtab
setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2
lua pcall(vim.treesitter.start)

function! s:ReactHandleCR() abort
  let lnum = line('.')
  let col = col('.')
  let line = getline(lnum)
  let before = strpart(line, 0, col - 1)
  let after = strpart(line, col - 1)
  let base_indent = indent(lnum)
  let inner_indent = repeat(' ', base_indent + shiftwidth())
  let close_indent = repeat(' ', base_indent)

  if before =~ '>\s*$' && after =~ '^\s*</'
    let closing = substitute(after, '^\s*', '', '')
    call setline(lnum, before)
    call append(lnum, inner_indent)
    call append(lnum + 1, close_indent . closing)
    call cursor(lnum + 1, strlen(inner_indent) + 1)
    startinsert
    return
  endif

  if before =~ '>\s*$' && after =~ '^\s*$'
    let next = nextnonblank(lnum + 1)
    if next > 0 && getline(next) =~ '^\s*</'
      call append(lnum, inner_indent)
      call cursor(lnum + 1, strlen(inner_indent) + 1)
      startinsert
      return
    endif
  endif
endfunction

function! s:ReactSmartCR() abort
  if pumvisible() && luaeval('_G.CmpPairsCR ~= nil')
    return luaeval('_G.CmpPairsCR()')
  endif

  let lnum = line('.')
  let col = col('.')
  let line = getline(lnum)
  let before = strpart(line, 0, col - 1)
  let after = strpart(line, col - 1)
  let next = nextnonblank(lnum + 1)

  if before =~ '>\s*$' && after =~ '^\s*</'
    return "\<C-g>u\<C-o>:call " . expand('<SID>') . "ReactHandleCR()\<CR>"
  endif

  if before =~ '>\s*$' && after =~ '^\s*$' && next > 0 && getline(next) =~ '^\s*</'
    return "\<C-g>u\<C-o>:call " . expand('<SID>') . "ReactHandleCR()\<CR>"
  endif

  return "\<CR>"
endfunction

inoremap <buffer><expr> <CR> <SID>ReactSmartCR()
