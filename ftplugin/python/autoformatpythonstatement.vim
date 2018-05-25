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
import re

line = vim.current.line
row, col = vim.current.window.cursor
space = ''

for char in line:
	if char == ' ' or char == '	':
		space = space + char
	else:
		break

extra = line[len(space):]
if extra == '':
	pass
else:
	oldextralen = len(extra)
	if extra == "##" and (row > 1 and (re.match("^\s*def ", vim.current.buffer[row-2]) or re.match("^\s*class ", vim.current.buffer[row-2]))):
		vim.current.line = space + '"""'
		vim.current.buffer.append("", row)
		vim.current.buffer[row] = space + '"""'
		vim.current.window.cursor = (row, len(space) + 3)
	elif extra != '':
		extra = autopep8.fix_code(extra)[:-1]
		if '\n' in extra:
			extras = extra.split('\n')
			for i in range(len(extras)-1):
				vim.current.buffer.append("", row)
			for i, v in enumerate(extras):
				vim.current.buffer[row + i - 1] = space + v
			vim.current.window.cursor = (row + len(extras) - 1, len(space) + len(extras[-1]))
		else:
			expandlen = len(extra) - oldextralen

			vim.current.line = space + extra
			vim.current.window.cursor = (row, col + expandlen)

endOfPython
endfunction

" --------------------------------
"  Expose our commands to the user
" --------------------------------

if g:autoformatpython_enabled == 1
	inoremap <silent> <buffer> <expr> <Cr> (getline('.') != '' && col(".") >= col("$")) ? '<Esc>:FormatCurrentLine<Cr>a<Cr>' : '<Cr>'
	nnoremap <silent> <buffer> <cr> :FormatCurrentLine<cr><cr>
endif

function! s:ChangeFormatCurrentLineMode()
	if g:autoformatpythonstate_mode == 1
		try
			iunmap <buffer> <Cr>
			nunmap <buffer> <Cr>
		catch
		endtry
		echom "Change Mode: Disable"
		let g:autoformatpythonstate_mode = 0
	else
		echom "Change Mode: Enable"
		inoremap <silent> <buffer> <expr> <Cr> (getline('.') != '' && col(".") >= col("$")) ? '<Esc>:FormatCurrentLine<Cr>a<Cr>' : '<Cr>'
		nnoremap <silent> <buffer> <cr> :FormatCurrentLine<cr><cr>
		let g:autoformatpythonstate_mode = 1
	endif
endfunction

command! ChangeFormatCurrentLineMode call s:ChangeFormatCurrentLineMode()
command! FormatCurrentLine call s:FormatCurrentLine()
