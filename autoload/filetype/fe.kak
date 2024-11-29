provide-module -override fe %{
	add-highlighter shared/fe regions
	add-highlighter shared/fe/code default-region group
	add-highlighter shared/fe/string region '"' (?<!\\)(\\\\)*" fill string
	add-highlighter shared/fe/comment region ';' '$' fill comment

	add-highlighter shared/fe/code/keyword regex \
		"\b(let|=|if|fn|mac|while|quote|and|or|do|cons|car|cdr|setcar|setcdr|list|not|is|atom|print|<|<=|-|\+|\*|/)\b" \
		1:keyword

	add-highlighter shared/fe/code/literal regex "\b(nil|t)\b" 1:value

	# yoinked from rc/filetype/c-family.kak

	# integer literals
	add-highlighter shared/fe/code/ regex %{(?i)(?<!\.)\b[1-9]('?\d+)*(ul?l?|ll?u?)?\b(?!\.)} 0:value
	add-highlighter shared/fe/code/ regex %{(?i)(?<!\.)\b0b[01]('?[01]+)*(ul?l?|ll?u?)?\b(?!\.)} 0:value
	add-highlighter shared/fe/code/ regex %{(?i)(?<!\.)\b0('?[0-7]+)*(ul?l?|ll?u?)?\b(?!\.)} 0:value
	add-highlighter shared/fe/code/ regex %{(?i)(?<!\.)\b0x[\da-f]('?[\da-f]+)*(ul?l?|ll?u?)?\b(?!\.)} 0:value

	# floating point literals
	add-highlighter shared/fe/code/ regex %{(?i)(?<!\.)\b\d('?\d+)*\.([fl]\b|\B)(?!\.)} 0:value
	add-highlighter shared/fe/code/ regex %{(?i)(?<!\.)\b\d('?\d+)*\.?e[+-]?\d('?\d+)*[fl]?\b(?!\.)} 0:value
	add-highlighter shared/fe/code/ regex %{(?i)(?<!\.)(\b(\d('?\d+)*)|\B)\.\d('?[\d]+)*(e[+-]?\d('?\d+)*)?[fl]?\b(?!\.)} 0:value
	add-highlighter shared/fe/code/ regex %{(?i)(?<!\.)\b0x[\da-f]('?[\da-f]+)*\.([fl]\b|\B)(?!\.)} 0:value
	add-highlighter shared/fe/code/ regex %{(?i)(?<!\.)\b0x[\da-f]('?[\da-f]+)*\.?p[+-]?\d('?\d+)*)?[fl]?\b(?!\.)} 0:value
	add-highlighter shared/fe/code/ regex %{(?i)(?<!\.)\b0x([\da-f]('?[\da-f]+)*)?\.\d('?[\d]+)*(p[+-]?\d('?\d+)*)?[fl]?\b(?!\.)} 0:value
}

hook global BufCreate .+\.fe$ %{
	set-option buffer filetype fe
}

hook global WinSetOption filetype=fe %{
	require-module fe
	set-option window static_words %opt{fe_static_words}
    set-option buffer extra_word_chars '_' '+' '-' '*' '/' '@' '$' '%' '^' '&' '_' '=' '<' '>' '~' '.'
}

hook -group fe-highlight global WinSetOption filetype=fe %{
	add-highlighter window/fe ref fe
	hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/fe }
}
