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

line = vim.current.line

space = ''

for char in line:
	print(char)
	if char == ' ' or char == '	':
		space = space + char
	else:
		break

extra = line[len(space):]
if extra != '':
	extra = autopep8.fix_code(extra)

vim.current.line = space + extra

endOfPython
endfunction

" --------------------------------
"  Expose our commands to the user
" --------------------------------
command! FormatCurrentLine call s:FormatCurrentLine()
