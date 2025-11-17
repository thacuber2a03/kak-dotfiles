hook -group lsp-filetype-lua global WinSetOption filetype=glsl %{
	set-option buffer lsp_servers %{
		[glsl_analyzer]
		root_globs = ["vertex.glsl", "fragment.glsl", "compile_commands.json", ".clangd", ".git", ".hg"]
	}
}
