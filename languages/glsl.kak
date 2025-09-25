try %{

evaluate-commands %sh{
	[ "$kak_opt_config_os" = Android ] && printf %s fail
}


hook global WinSetOption filetype=glsl %{
	set-option buffer lsp_servers %{
		[glsl_analyzer]
		root_globs = ["vertex.glsl", "fragment.glsl", "compile_commands.json", ".clangd", ".git", ".hg"]
	}
}

}
