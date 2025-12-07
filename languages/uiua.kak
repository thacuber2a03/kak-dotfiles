hook global BufSetOption filetype=uiua %{
	set-option buffer indentwidth 2
	set-option buffer tabstop 8
}

# FIX(thacuber2a03): I actually don't know how else to check for kak-lsp
try %{
	set-option global lsp_servers %opt{lsp_servers}

	hook -group lsp-filetype-uiua global BufSetOption filetype=uiua %{
		set-option buffer lsp_servers %{
			[uiua-lsp]
			command = "uiua"
			args = ["lsp"]
			root_globs = [".git", "main.ua"]
		}

		set-option buffer lsp_semantic_tokens %{
			[
				{face="comment", token="uiua_comment"},
				{face="module", token="uiua_module"},
				{face="string", token="uiua_string"},
				{face="number", token="uiua_number"},

				{face="UiuaMonadicFunction", token="monadic_function"},
				{face="UiuaDyadicFunction", token="dyadic_function"},
				{face="UiuaTriadicFunction", token="triadic_function"},
				{face="UiuaMonadicModifier", token="monadic_modifier"},
				{face="UiuaDyadicModifier", token="dyadic_modifier"},
			]
		}
	}

	hook global WinSetOption filetype=uiua %{
		hook window -group lsp-semantic-tokens-uiua BufReload .* lsp-semantic-tokens
		hook window -group lsp-semantic-tokens-uiua NormalIdle .* lsp-semantic-tokens
		hook window -group lsp-semantic-tokens-uiua InsertIdle .* lsp-semantic-tokens
		hook -once -always window WinSetOption filetype=.* %{
			remove-hooks window lsp-semantic-tokens-uiua
		}
	}
} catch %{
	config-log trace '[uiua] kak-lsp not detected, defaulting to uiua fmt --io'
	config-set-formatter uiua 'uiua fmt --io'
}
