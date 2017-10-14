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
row, col = vim.current.window.cursor
space = ''

for char in line:
	print(char)
	if char == ' ' or char == '	':
		space = space + char
	else:
		break

extra = line[len(space):]
if extra == '':
	pass
else:
	oldextralen = len(extra)
	if extra != '':
		extra = autopep8.fix_code(extra)[:-1]
	expandlen = len(extra) - oldextralen

	vim.current.line = space + extra
	vim.current.window.cursor = (row, col + expandlen)

endOfPython
endfunction

" --------------------------------
"  Expose our commands to the user
" --------------------------------
command! FormatCurrentLine call s:FormatCurrentLine()

if g:autoformatpython_enabled == 1
	execute "autocmd FileType python inoremap <silent> <buffer> <Cr> <Esc>:FormatCurrentLine<Cr>a<Cr>"
endif

function! s:ChangeFormatCurrentLineMode()
	if g:autoformatpythonstate_mode == 1
		try
			iunmap <Cr>
		catch
		endtry
		let g:autoformatpythonstate_mode = 0
	else
		execute "autocmd FileType python inoremap <silent> <buffer> <Cr> <Esc>:FormatCurrentLine<Cr>a<Cr>"
		let g:autoformatpythonstate_mode = 1
	endif
endfunction

command! ChangeFormatCurrentLineMode call s:ChangeFormatCurrentLineMode()
