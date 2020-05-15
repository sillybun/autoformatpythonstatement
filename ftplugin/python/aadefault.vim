if !exists('g:autoformatpython_enabled')
	let g:autoformatpython_enabled = 1
	let g:autoformatpythonstate_mode = 1
elseif !exists('g:autoformatpythonstate_mode')
	if g:autoformatpython_enabled ==# 1
		let g:autoformatpythonstate_mode = 1
	else
		let g:autoformatpythonstate_mode = 0
	endif
endif


if !exists('g:autoformatpython_break_long_lines')
    let g:autoformatpython_break_long_lines = 0
endif
