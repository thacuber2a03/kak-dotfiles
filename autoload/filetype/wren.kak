provide-module -override wren %§
	add-highlighter shared/wren regions
	add-highlighter shared/wren/line_comment region '//' '$' fill comment
	add-highlighter shared/wren/block_comment region -recurse '/\*' '/\*' '\*/' fill comment
	add-highlighter shared/wren/raw_string region '"""' '(?<!\\)(?:\\\\)*"""' fill string
	add-highlighter shared/wren/string region '"' '(?<!\\)(\\\\)*"' group
	add-highlighter shared/wren/string/ fill string
	add-highlighter shared/wren/string/ regex '\\([0"\\%abefnrtv]|x[\dA-Fa-f]{2}|u[\dA-Fa-f]{4}|U[\dA-Fa-f]{8})'0:value
	add-highlighter shared/wren/string/ regex '(?<!\\)%\(.*?\)' 0:meta

	add-highlighter shared/wren/code default-region group

	add-highlighter shared/wren/code/ regex '(?i)([a-z][\w_]*)\h*(?=[\(\{])' 1:function
	add-highlighter shared/wren/code/ regex '(?i)([a-z][\w_]*)=\(.*?\)\h*(?=\{)' 1:function
	add-highlighter shared/wren/code/ regex 'class\h+(?i)([a-z][\w_]*)\h*(?=\{)' 1:type
	add-highlighter shared/wren/code/ regex 'construct\h+(?i)([a-z][\w_]*)\h*(?=\()' 1:meta
	add-highlighter shared/wren/code/ regex 'var\h+(?i)([a-z][\w_]*)' 1:variable

	add-highlighter shared/wren/code/ regex '_[\w_]+' 0:variable

	add-highlighter shared/wren/code/ regex '\bimport\b' 0:meta
	add-highlighter shared/wren/code/ regex '\b(true|false|null)\b' 0:value
	add-highlighter shared/wren/code/ regex '\b(as|break|class|construct|continue|else|for|foreign|if|in|return|static|super|this|var|while)\b' 0:keyword
	add-highlighter shared/wren/code/ regex '\b(Bool|Class|Fiber|Fn|List|Map|Null|Num|Object|Range|Sequence|String|System)\b' 0:+b@type
	add-highlighter shared/wren/code/ regex '(-|!|~|\*|/|%|\+|\.\.\.?|<<|>>|&{1,2}|\^|\|{1,2}|[<>]=?)|\bis\b|[!=]?=|\?|:)' 0:operator

	add-highlighter shared/wren/code/ regex '\b(?i)-?\d+\b'               0:value
	add-highlighter shared/wren/code/ regex '\b-?0x(?i)[\da-f]+\b'        0:value
	add-highlighter shared/wren/code/ regex '\b(?i)-?\d+\.\d+\b'          0:value
	add-highlighter shared/wren/code/ regex '\b(?i)-?\d+\.\d+e[+-]?\d+\b' 0:value

	add-highlighter shared/wren/code/ regex '^\h*import\h*"(.*?)"' 1:module
	add-highlighter shared/wren/code/ regex '\bFn\.new\h*(?=\{)' 0:+b@value
§

hook global BufCreate (.*/)?.*\.wren %{ set-option buffer filetype wren }

hook -group wren-highlight global WinSetOption filetype=wren %{
    require-module wren
    add-highlighter window/wren ref wren
    hook -once -always window WinSetOption filetype=.* %{
        remove-highlighter window/wren
    }
}
