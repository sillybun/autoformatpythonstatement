if !exists('g:autoformatpython_enabled')
	let g:autoformatpython_enabled = 0
	let g:autoformatpythonstate_mode = 0
elseif !exists('g:autoformatpythonstate_mode')
	if g:autoformatpython_enabled ==# 1
		echom "hello from default"
		let g:autoformatpythonstate_mode = 1
	else
		let g:autoformatpythonstate_mode = 0
	endif
endif
