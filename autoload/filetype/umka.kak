provide-module -override umka %§
	add-highlighter shared/umka regions

	add-highlighter shared/umka/ region '//'  '$'   fill comment
	add-highlighter shared/umka/ region '/\*' '\*/' fill comment

	add-highlighter shared/umka/double_string region '"' '(?<!\\)(\\\\)*"' group
	add-highlighter shared/umka/double_string/ fill string
	add-highlighter shared/umka/double_string/ regex '\\([0abefnrtv\\]|x(?i)[\da-f]{2})' 0:value

	add-highlighter shared/umka/single_string region "'" "(?<!\\)(\\\\)*'" group
	add-highlighter shared/umka/single_string/ fill value
	add-highlighter shared/umka/single_string/ regex '\\([0abefnrtv\\]|x(?i)[\da-f]{2})' 0:meta

	add-highlighter shared/umka/printf region '\bprintf\(\K"' '".*?\)' group
	# add-highlighter shared/umka/printf/ regex '(\bprintf)\K\((?:.*?)\)' 0:default 1:builtin
	add-highlighter shared/umka/printf/ ref umka/double_string
	add-highlighter shared/umka/printf/ regex '%(ll?|hh?)?[diuxXfFeEgGscv]' 0:value

	add-highlighter shared/umka/code default-region group

	add-highlighter shared/umka/code/ regex '\b(true|false|null)\b' 0:value

	add-highlighter shared/umka/code/ regex "\b([a-z_][\w_]*)\b\h*(?=\()" 1:function

	add-highlighter shared/umka/code/ regex \
	'\b(break|case|const|continue|default|else|enum|fn|for|import|interface|if|in|map|return|struct|switch|type|var|weak)\b' \
	0:keyword

	add-highlighter shared/umka/code/ regex \
	'\b([fs]?(print|scan)f|round|trunc|ceil|floor|abs|fabs|sqrt|sin|cos|atan|atan2|exp|log)\b' \
	0:builtin

	add-highlighter shared/umka/code/ regex \
	'\b(new|make|copy|append|insert|delete|slice|sort|len|cap|sizeof|sizeofself|selfhasptr|selftypeeq|typeptr|valid|validkey|keys|resume|memusage|exit)\b' \
	0:builtin

	add-highlighter shared/umka/code/ regex '^\h*(import)\h*"(?:.*/)?(.*)\.um"\h*$' 1:meta 2:module

	add-highlighter shared/umka/code/ regex '\B\.[a-z_][\w_]*\b' 0:value

	add-highlighter shared/umka/code/ regex '\b(real(32)?|u?int(8|16|32)?)\b'    0:+b@type
	add-highlighter shared/umka/code/ regex '\b(bool|char|str|void|fiber|any)\b' 0:+b@type

	add-highlighter shared/umka/code/ regex 'type\h+(?i)([a-z_][\w_]*)'                  1:type
	add-highlighter shared/umka/code/ regex 'const\h+(?i)([a-z_][\w_]*)'                 1:value
	add-highlighter shared/umka/code/ regex '(?i)([a-z_][\w_]*)(?:\h*,\h*([a-z_][\w_]*))\h*(?=:=)' 1:variable

	add-highlighter shared/umka/code/ regex '\b[A-Z][\w_]*\b' 0:type

	add-highlighter shared/umka/code/ regex '((([-\+\*/%&\|~!=:<>])|<<|>>)=?|\+\+|--|&&|\|\||::|\.\.|\?|\^)' 0:operator

	add-highlighter shared/umka/code/ regex '([a-z_][\w_]*)::[a-z_][\w_]*' 1:module

	add-highlighter shared/umka/code/ regex 'fn\h*\(.*?\)\h*(\|).*?(\|)' 1:attribute 2:attribute

	add-highlighter shared/umka/code/ regex '\b(?i)-?\d+\b'            0:value
	add-highlighter shared/umka/code/ regex '\b-?0x(?i)[\da-f]+\b'     0:value
	add-highlighter shared/umka/code/ regex '\b(?i)-?\d+\.\d+\b'       0:value
	add-highlighter shared/umka/code/ regex '\b(?i)-?\d+\.\d+e-?\d+\b' 0:value
	add-highlighter shared/umka/code/ regex '\b(?i)-?\d+e-?\d+\b'      0:value
§

hook global -group umka-highlight WinSetOption filetype=umka %{
	require-module umka
	add-highlighter window/umka ref umka
	hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/umka }
}

hook global BufCreate (.*/)?.*\.um %{ set-option buffer filetype umka }
