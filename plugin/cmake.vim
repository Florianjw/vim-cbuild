" basic cmake-integration for vim
" Maintainer:   Florian Weber <oss@florianjw.de>
" Version:      0.01

" Some basic ideas are taken from https://github.com/vhdirk/vim-cmake
" but at this point it is basically completely rewritten from scratch

let s:cbuild_plugin_version = '0.01'

if exists("loaded_cbuild_plugin")
	finish
endif
let loaded_cbuild_plugin = 1

" Public Interface:
command! -nargs=? CBuild call s:cbuild(<f-args>)

function! s:cbuild(...)
	if a:0 == 0
		if exists("g:cmake_default_build_type")
			let s:build_type=g:default_build_type
		else
			let s:build_type="debug"
		endif
	elseif a:0 == 1
		let s:build_type=a:1
	else
		echo "invalid number of arguments"
		return 1
	endif
	
	let s:build_dir_base = finddir('build', '.;')

	if s:build_dir_base == ""
		echo "Unable to find build directory."
		return 2
	endif

	let s:build_dir = s:build_dir_base."/".s:build_type

	if isdirectory(s:build_dir) == 0
		echo "Build-directory not found: " . s:build_dir
		return 3
	endif

	echo "type = " . s:build_type
	echo "Build-dir = ".s:build_dir
	exec 'cd' s:build_dir
	let s:cmd = "cmake -GNinja ../.."
	let s:res = system(s:cmd)
	echo s:res
	let s:res = system("ninja")
	echo s:res
	exec 'cd -'
endfunction