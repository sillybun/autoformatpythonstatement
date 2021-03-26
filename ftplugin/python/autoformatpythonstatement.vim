" --------------------------------
" Add our plugin to the path
" --------------------------------
if !has('python3')
    echoerr "This Plugin can only with python3 support"
    finish
endif

python3 import sys
python3 import vim
python3 sys.path.append(vim.eval('expand("<sfile>:h")'))

function! Strip(input_string) abort
    return substitute(a:input_string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

" --------------------------------
"  Function(s)
" --------------------------------
function! s:FormatCurrentLine() abort
python3 << endOfPython

import autopep8
import re
import astformat

line = vim.current.line
row, col = vim.current.window.cursor
space = ''
if len(line) > 79:
    toolong = True
else:
    toolong = False

extra = line.lstrip()
space = " " * (len(line) - len(extra))

if extra == '':
    vim.current.line = ""
    vim.current.window.cursor = (row, 1)
if "#" in line:
    pass
else:
    oldextralen = len(extra)
    if extra == "##" and (row > 1 and (re.match("^\s*def ", vim.current.buffer[row-2]) or re.match("^\s*class ", vim.current.buffer[row-2]))):
        vim.current.line = space + '"""'
        vim.current.buffer.append("", row)
        vim.current.buffer[row] = space + '"""'
        vim.current.window.cursor = (row, len(space) + 3)
    elif extra != '':
        flag = False
        if toolong and vim.eval("g:autoformatpython_break_long_lines") == '1':
            try:
                extra, flag = astformat.formatif(extra)
            except:
                pass
        if not flag:
            try:
                extra = autopep8.fix_code(extra)[:-1]
            except Exception as e:
                print(e)
            else:
                if vim.eval("g:autoformatpython_break_long_lines") == "1":
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
                else:
                    if '\n' in extra:
                        temp = extra.split("\n")
                        temp = [x.rstrip("\\") for x in temp]
                        extra = temp[0]
                        for x in temp[1:]:
                            x = x.lstrip()
                            if extra[-1] in ["(", "[", "{"]:
                                extra = extra + x
                            else:
                                extra = extra + " " + x
                    expandlen = len(extra) - oldextralen
                    vim.current.line = space + extra
                    vim.current.window.cursor = (row, col + expandlen)

endOfPython
endfunction

function! s:FormatCurrentLineandIndent() abort
python3 << endOfPython

import time
import vim
import ZYTFDUAUTOFORMATvimbufferutil

line = vim.current.line
row, col = vim.current.window.cursor

if line.strip() == "":
    vim.current.line = ""
    if vim.eval("b:autoformat_lastlength") != "-1":
        line = " " * int(vim.eval("b:autoformat_lastlength"))
    vim.current.buffer.append(line, row)
    vim.current.window.cursor = (row + 1, len(line))
else:
    vim.command("call s:FormatCurrentLine()")
    line = vim.current.line
    row, col = vim.current.window.cursor

    extra = line.strip()

    if extra == "":
        vim.current.line = ""
        vim.current.buffer.append(line, row)
        vim.current.window.cursor = (row + 1, len(line))
    else:
        indentlevel, finishflag, unfinishedtype = ZYTFDUAUTOFORMATvimbufferutil.getcurrentindent(vim.current.buffer, row)
        if not finishflag:
            if unfinishedtype == 6:
                nextindentlevel = indentlevel
            else:
                nextindentlevel = indentlevel + 2
        elif vim.current.line[-1] == ":":
            nextindentlevel = indentlevel + 1
        else:
            nextindentlevel = indentlevel

        vim.current.buffer.append(" " * (4 * (nextindentlevel)), row)
        vim.current.window.cursor = (row + 1, 4 * (nextindentlevel))

vim.command("let b:autoformat_lastlength = -1")


endOfPython
endfunction

function! s:ExitInsertMode() abort
python3 << endOfPython

row, col = vim.current.window.cursor

if vim.current.line.strip() == "":
    vim.current.window.cursor = (row, 1)
    vim.current.line = ""

endOfPython
endfunction

" --------------------------------
"  Expose our commands to the user
" --------------------------------

function! SaveCurrentLength() abort
python3 << endOfPython
import vim
line = vim.current.line
vim.command("let b:autoformat_lastlength = {}".format(len(line)))
endOfPython
return ''
endfunction

if g:autoformatpython_enabled == 1
    " inoremap <silent> <buffer> <expr> <Cr> (Strip(getline('.')) != '' && col(".") >= col("$")) ? '<Esc>:FormatCurrentLine<Cr>a<Cr>' : '<Cr>'
    " inoremap <silent> <expr> <buffer> <Cr> '<C-o>:FormatCurrentLineandIndent<Cr>'
    inoremap <silent> <expr> <buffer> <Cr> (col(".") >= col("$")) ? SaveCurrentLength() . '<C-o>:FormatCurrentLineandIndent<Cr>' : '<Cr>'
    "inoremap <silent> <buffer> <expr> <Esc> '<Esc>:AFExitInsertMode<Cr>'
    nnoremap <silent> <buffer> <cr> :FormatCurrentLine<cr><cr>
    augroup afpsgroup
        autocmd!
        autocmd! InsertLeave *.py call s:ExitInsertMode()
    augroup END
endif

function! s:ChangeFormatCurrentLineMode()
    if g:autoformatpythonstate_mode == 1
        try
            iunmap <buffer> <Cr>
            nunmap <buffer> <Cr>
        catch
        endtry
        augroup afpsgroup
            autocmd!
        augroup END
        echom "Change Mode: Disable"
        let g:autoformatpythonstate_mode = 0
    else
        echom "Change Mode: Enable"
        if g:autoformatpython_insertmode == 1:
            inoremap <silent> <expr> <buffer> <Cr> (col(".") >= col("$")) ? SaveCurrentLength() . '<C-o>:FormatCurrentLineandIndent<Cr>' : '<Cr>'
        endif
        "inoremap <silent> <buffer> <expr> <Esc> '<Esc>:AFExitInsertMode<Cr>'
        nnoremap <silent> <buffer> <cr> :FormatCurrentLine<cr><cr>
        augroup afpsgroup
            autocmd!
            autocmd! InsertLeave *.py call s:ExitInsertMode()
        augroup END
        let g:autoformatpythonstate_mode = 1
    endif
endfunction

let b:autoformat_lastlength = -1

command! ChangeFormatCurrentLineMode call s:ChangeFormatCurrentLineMode()
command! FormatCurrentLine call s:FormatCurrentLine()
command! FormatCurrentLineandIndent call s:FormatCurrentLineandIndent()
command! AFExitInsertMode call s:ExitInsertMode()
