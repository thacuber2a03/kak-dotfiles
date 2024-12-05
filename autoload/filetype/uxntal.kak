provide-module -override uxntal %{
	add-highlighter shared/uxntal         regions
	add-highlighter shared/uxntal/ region -recurse '(?<=\s)\((?=\s)' '^\((?=\s)'       '(?<=\s)\)(?=\s)' fill comment
	add-highlighter shared/uxntal/ region -recurse '(?<=\s)\((?=\s)' '(?<=\s)\((?=\s)' '(?<=\s)\)(?=\s)' fill comment
	add-highlighter shared/uxntal/code    default-region group

	add-highlighter shared/uxntal/code/ regex "\bBRK\b"                                                                        0:keyword
	add-highlighter shared/uxntal/code/ regex "\bLIT([2r]{2})?\b"                                                                 0:keyword
	add-highlighter shared/uxntal/code/ regex "\b(INC|POP|NIP|SWP|ROT|DUP|OVR|EQU|NEQ|GTH|LTH|JMP|JCN|JSR|STH)[2kr]{,3}\b"     0:keyword
	add-highlighter shared/uxntal/code/ regex "\b(LDZ|STZ|LDR|STR|LDA|STA|DEI|DEO|ADD|SUB|MUL|DIV|AND|ORA|EOR|SFT)[2kr]{,3}\b" 0:keyword

	add-highlighter shared/uxntal/code/ regex "[!?][^\s]+"        0:function
	add-highlighter shared/uxntal/code/ regex "[-_=,;.][^\s]+"    0:variable
	add-highlighter shared/uxntal/code/ regex '"[^\s]+'           0:string
	add-highlighter shared/uxntal/code/ regex "[|$][0-9a-f]+"     0:value
	add-highlighter shared/uxntal/code/ regex "\b[0-9a-f]{2,4}\b" 0:value
	add-highlighter shared/uxntal/code/ regex "#[0-9a-f]{2,4}"    0:value
	add-highlighter shared/uxntal/code/ regex "%[^\s]+"           0:meta
	add-highlighter shared/uxntal/code/ regex "@[^\s]+"           0:module
	add-highlighter shared/uxntal/code/ regex "&[^\s]+"           0:function
}

hook global BufCreate (.*/)?.*\.tal %{ set-option buffer filetype uxntal }

hook global WinSetOption filetype=uxntal %{
    require-module uxntal
    add-highlighter window/uxntal ref uxntal
    hook -once -always window WinSetOption filetype=.* %{
        remove-highlighter window/uxntal
    }
}
