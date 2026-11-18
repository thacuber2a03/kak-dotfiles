hook global BufCreate .*\.tl %{ set-option buffer filetype teal }

config-enable-lsp-support teal %{
	[teal-language-server]
	root_globs = ["main.tl", ".git", ".hg"]
}
