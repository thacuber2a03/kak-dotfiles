hook -group	lsp-filetype-lua global BufSetOption filetype=lua %{
	set-option buffer lsp_servers %{
		[lua-language-server]
		root_globs = [".git", ".hg", "main.lua"]
		settings_section = "Lua"
		[lua-language-server.settings.Lua]
		completion = { callSnippet = "Replace" }

		# See https://github.com/sumneko/vscode-lua/blob/master/setting/schema.json

		[lua-language-server.settings.Lua.format.defaultConfig]
		indent_style = "tab"
		tab_width = "4"
		quote_style = "none"
		call_arg_parentheses = "remove"
		continuation_indent = "smart"
		trailing_table_separator = "smart"
		insert_final_newline = "false"
		align_if_branch = "true"
		align_continuous_rect_table_field = "true"
		space_around_table_append_operator = "true"
		never_indent_before_if_condition = "true"
		line_space_after_function_statement = "max(2)"
		end_statement_with_semicolon = "same_line"
	}
}
