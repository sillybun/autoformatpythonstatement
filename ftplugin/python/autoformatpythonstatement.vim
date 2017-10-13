" --------------------------------
" Add our plugin to the path
" --------------------------------
python3 import sys
python3 import vim
python3 sys.path.append(vim.eval('expand("<sfile>:h")'))

" --------------------------------
"  Function(s)
" --------------------------------
function! s:FormatCurrentLine()
python3 << endOfPython

import autopep8

vim.current.line = autopep8.fix_code(vim.current.line)

endOfPython
endfunction

" --------------------------------
"  Expose our commands to the user
" --------------------------------
command! FormatCurrentLine call s:FormatCurrentLine()
