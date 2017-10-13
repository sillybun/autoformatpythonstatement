if !exists(g:autoformatpython_enabled)
	let g:autoformatpython_enabled = 0
	let g:autoformatpythonstate_mode = 0
elseif !exists(g:autoformatpythonstate_mode)
	let g:autoformatpythonstate_mode = 1
endif


if !exists(g:autoformatpythonstate_mode)
	let g:autoformatpythonstate_mode = 0
endif
