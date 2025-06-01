provide-module uxntal %§
	add-highlighter shared/uxntal regions

	add-highlighter shared/uxntal/comment region -recurse '\(' '(?<!")\(' '\)' fill comment
	add-highlighter shared/uxntal/macro region '%\w+\s*\{' '\}' group
	add-highlighter shared/uxntal/macro/ regex '%\w+\s*\{' 0:meta
	add-highlighter shared/uxntal/macro/ regex '\}' 0:meta
	add-highlighter shared/uxntal/macro/ ref uxntal/code

	add-highlighter shared/uxntal/code default-region group
	add-highlighter shared/uxntal/code/ regex '(?I)(?<=\s)([\da-f]{2}|[\da-f]{4})(?=\s)' 0:meta
	add-highlighter shared/uxntal/code/ regex '(?I)(?<=\s)#([\da-f]{2}|[\da-f]{4})(?=\s)' 0:value
	add-highlighter shared/uxntal/code/ regex '(?I)\|[\da-f]+' 0:attribute
	add-highlighter shared/uxntal/code/ regex '(?I)\$[\da-f]+' 0:meta
	add-highlighter shared/uxntal/code/ regex '(?I)@\S+' 0:module
	add-highlighter shared/uxntal/code/ regex '(?I)&\S+' 0:function
	add-highlighter shared/uxntal/code/ regex '(?I)[,.;]\S+' 0:variable
	add-highlighter shared/uxntal/code/ regex '(?I)(?<=\s)[-=_]\S+' 0:meta
	add-highlighter shared/uxntal/code/ regex '"\S+' 0:string

	add-highlighter shared/uxntal/code/ regex \
		'\b(INC|POP|NIP|SWP|ROT|DUP|OVR|EQU|NEQ|GTH|LTH|JMP|JCN|JSR|STH|LDZ|STZ|LDR|STR|LDA|STA|DEI|DEO|ADD|SUB|MUL|DIV|AND|ORA|EOR|SFT)[2kr]{,3}\b' 0:keyword

	add-highlighter shared/uxntal/code/ regex '\bLIT[2r]{,2}\b' 0:keyword
	add-highlighter shared/uxntal/code/ regex '\bBRK\b'        0:keyword
§

hook global BufCreate .+\.tal %{ set-option buffer filetype uxntal }

hook global -group uxntal-highlight WinSetOption filetype=uxntal %{
	require-module uxntal
	add-highlighter window/uxntal ref uxntal
	hook -once -always window WinSetOption filetype=.* %{
		remove-highlighter window/uxntal
	}
}

hook global WinSetOption filetype=uxntal %{
	require-module uxntal
}
