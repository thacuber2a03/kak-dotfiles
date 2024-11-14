provide-module -override umka %§
    add-highlighter shared/umka regions

    add-highlighter shared/umka/ region '//' '\n' fill comment
    add-highlighter shared/umka/ region '/\*' '\*/' fill comment

    add-highlighter shared/umka/double_string region '"' '"' group

    add-highlighter shared/umka/double_string/ fill string

    add-highlighter shared/umka/code default-region group

    add-highlighter shared/umka/code/ \
    	regex true|false 0:value

    add-highlighter shared/umka/code/ \
    	regex \b(import|var|const|struct|interface|enum|type|fn|if|else|for|in|while|return|continue|break|case|default|weak|map)\b 0:keyword

    add-highlighter shared/umka/code/ \
    	regex \b((real|u?int)(8|16|32)?)\b 0:type

    add-highlighter shared/umka/code/ \
    	regex \b(bool|char|str|void)\b 0:type

	add-highlighter shared/umka/code/operator regex \
		"(\+|-|\*|/|%|\^|\+\+|--|\+=|-=|\*=|/=|%=|==|!=|>|<|>=|<=|&|&&|\|\||!|:=|\.\.\.?)" 1:operator
§

hook global WinSetOption filetype=umka %{
    require-module umka

    add-highlighter window/umka ref umka

    hook -once -always window WinSetOption filetype=.* %{
        remove-highlighter window/umka
    }
}

hook global BufCreate .+\.um %{
    set-option buffer filetype umka
}
