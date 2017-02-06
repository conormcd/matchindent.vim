" A Vim plugin which attempts to set tab preferences to match the file you're
" editing.
" 
" Last Change: 2012-04-27
" Maintainer: http://github.com/conormcd
" License: www.opensource.org/licenses/bsd-license.php

highlight MatchIndentBadIndent ctermbg=red guibg=red
autocmd BufNewFile,BufRead * call MatchIndent()
function! MatchIndent()
	" Zip through the first few lines and look for the three most common
	" indenting schemes.
	let n = 1
	let nmax = 500
	let with_tabs = 0
	let with_2_spaces = 0
	let with_4_spaces = 0
	while n <= nmax
		let cur_line = getline(n)

		if cur_line =~ '^	'
			let with_tabs = with_tabs + 1
		elseif cur_line =~ '^  [^ ]'
			let with_2_spaces = with_2_spaces + 1
		elseif cur_line =~ '^    [^ ]'
			let with_4_spaces = with_4_spaces + 1
		endif

		let n = n + 1
	endwhile

	" Figure out which indentation scheme we're going to use.
	let use_tabs = 0
	let use_2_spaces = 0
	let use_4_spaces = 0
	let warn_tabs = 0
	let warn_spaces = 0
	let warn_2_spaces = 0
	if with_tabs == 0 && with_2_spaces == 0 && with_4_spaces == 0
		" Have to guess from syntax
		if exists('b:current_syntax') && b:current_syntax == 'python'
			let use_4_spaces = 1
			let warn_tabs = 1
		elseif exists('b:current_syntax') && b:current_syntax == 'ruby'
			let use_2_spaces = 1
			let warn_tabs = 1
		else
			" We don't make any changes to the user's specified default in
			" their vimrc
		endif
	elseif with_tabs == 0 && with_2_spaces == 0 && with_4_spaces > 0
		" Clear case of a 4 space indent
		let use_4_spaces = 1
		let warn_tabs = 1
		let warn_2_spaces = 1
	elseif with_tabs == 0 && with_2_spaces > 0 && with_4_spaces == 0
		" Clear case of a 2 space indent
		let use_2_spaces = 1
		let warn_tabs = 1
	elseif with_tabs == 0 && with_2_spaces > 0 && with_4_spaces > 0
		" Mix of 2 and 4 space indents, we assume a 2 space indent since 4
		" space indents happen in 2 space indent files. It's not perfect, but
		" hey...
		" Only use 4 if theres 4 times as many lines with 4 spaces.
		if with_2_spaces * 4 > with_4_spaces
			let use_2_spaces = 1
		else
			let use_4_spaces = 1
		endif
		let warn_tabs = 1
	elseif with_tabs > 0 && with_2_spaces == 0 && with_4_spaces == 0
		" Clear case of tab indents
		let use_tabs = 1
		let warn_spaces = 1
	elseif with_tabs > 0 && with_2_spaces == 0 && with_4_spaces > 0
		" Mix of tabs and 4 space indents
		if with_tabs > with_4_spaces
			let use_tabs = 1
			let warn_spaces = 1
		else
			let use_4_spaces = 1
			let warn_tabs = 1
		endif
	elseif with_tabs > 0 && with_2_spaces > 0 && with_4_spaces == 0
		" Mix of tabs and 2 space indents
		if with_tabs > with_2_spaces
			let use_tabs = 1
			let warn_spaces = 1
		else
			let use_2_spaces = 1
			let warn_tabs = 1
		endif
	else " with_tabs > 0 && with_2_spaces > 0 && with_4_spaces > 0
		" All three!
		let warn_tabs = 1
		let warn_spaces = 1
	endif

	" Actually apply the rules now
	if use_tabs > 0
		set noexpandtab
		set shiftwidth=4
		set softtabstop=4
		set tabstop=4
	endif
	if use_2_spaces > 0
		set expandtab
		set shiftwidth=2
		set softtabstop=2
		set tabstop=2
	endif
	if use_4_spaces > 0
		set expandtab
		set shiftwidth=4
		set softtabstop=4
		set tabstop=4
	endif
	if warn_tabs > 0
		match MatchIndentBadIndent /^\t\+/
	endif
	if warn_spaces > 0
		match MatchIndentBadIndent /^\(  \)+/
	endif
	if warn_2_spaces > 0
		match MatchIndentBadIndent /^  [^ ]/
	endif
endfunction
