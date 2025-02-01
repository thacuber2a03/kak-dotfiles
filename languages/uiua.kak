hook global BufCreate .*\.ua %{
	set-option buffer filetype uiua
}

config-set-formatter uiua 'uiua fmt --io'

hook -group lsp-filetype-uiua global BufSetOption filetype=uiua %{
	set-option buffer lsp_servers %{
		[lua-language-server]
		root_globs = [".git", ".hg"]
		settings_section = "Lua"
		[lua-language-server.settings.Lua]

		# See https://github.com/sumneko/vscode-lua/blob/master/setting/schema.json

		[lua-language-server.settings.format.defaultConfig]
		indent_style = "tab"
		tab_width = "4"
		quote_style = "none"
		call_arg_parentheses = "remove"
		continuation_indent = "smart"
		insert_final_newline = "false"
		never_indent_before_if_condition = "true"
		line_space_after_function_statement = "max(2)"
		end_statement_with_semicolon = "same_line"
	}
}
