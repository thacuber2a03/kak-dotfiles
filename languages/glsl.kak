config-enable-lsp-support glsl %{
	[glsl_analyzer]
	root_globs = ["vertex.glsl", "fragment.glsl", "compile_commands.json", ".clangd", ".git", ".hg"]
}

hook global BufCreate .+\.(vert|frag|geom|comp) %{ set-option buffer filetype glsl }
