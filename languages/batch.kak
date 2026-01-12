# mostly based on Lite XL's language_batch.lua:
# https://raw.githubusercontent.com/lite-xl/lite-xl-plugins/refs/heads/master/plugins/language_batch.lua

provide-module batch %§
	add-highlighter shared/batch regions

	add-highlighter shared/batch/ region '(?i)rem|::(?![\w-])' '$' fill comment

	# TODO: does batch even have escapes???
	add-highlighter shared/batch/string region '"' (?<!\\)(\\\\)*" group
	add-highlighter shared/batch/string/ fill string
	add-highlighter shared/batch/string/ regex '\\.' 0:value
	add-highlighter shared/batch/string/ regex '%%?~?[\w:]+\b' 0:value
	add-highlighter shared/batch/string/ regex '%[\w:,~\-\d]+%' 0:variable

	add-highlighter shared/batch/code default-region group

	add-highlighter shared/batch/code/ regex '[!=>&^/\\@]' 0:operator

	add-highlighter shared/batch/code/ regex '-?\.?\d+f?\b' 0:value

	add-highlighter shared/batch/code/ regex '%%?~?[\w:]+\b' 0:value
	add-highlighter shared/batch/code/ regex '%[\w:,~\d]+%' 0:variable

	add-highlighter shared/batch/code/ regex \
		'(?i)\b(if|else|not|for|do|in|nul|con|prn|lpt1|com1|com2|com3|com4|exist|defined|errorlevel|cmdextversion|goto|call|verify|pushd|popd)\b' \
		0:keyword

	add-highlighter shared/batch/code/ regex '(?i)\b(equ|neq|lss|leq|gtr|geq)\b' 0:operator

	add-highlighter shared/batch/code/ regex \
		'(?i)\b(set|setlocal|endlocal|enabledelayedexpansion|echo|type|cd|chdir|md|mkdir|pause|choice|exit|del|rd|rmdir|copy|xcopy|move|ren|find|findstr|sort|shift|attrib|cmd|command|forfiles)\b' \
		0:function

	add-highlighter shared/batch/code/ regex '@echo (on|off)$' 0:meta

	declare-option str-list batch_static_words \
		if else not for do in equ neq lss leq gtr geq nul con prn lpt1 com1 com2 com3 \
		com4 exist defined errorlevel cmdextversion goto call verify set setlocal \
		endlocal enabledelayedexpansion echo type cd chdir md mkdir pause choice exit \
		del rd rmdir copy xcopy move ren find findstr sort shift attrib cmd command \
		forfiles
§

hook global BufSetOption filetype=bat(?:ch)? %{
	set-option buffer filetype msdos-batch # to align with rc/detection/file.kak
}

hook -group msdos-batch-highlight global WinSetOption filetype=msdos-batch %{
	require-module batch
	add-highlighter window/batch ref batch
	hook -once -always window WinSetOption filetype=.* %{
		remove-highlighter window/batch
	}
}

hook global WinSetOption filetype=msdos-batch %{
	require-module batch

	set-option buffer static_words %opt{batch_static_words}
}
