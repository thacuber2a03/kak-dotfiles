config-enable-lsp-support purescript %{
	[purescript-language-server]
	root_globs = ["spago.dhall", "spago.yaml", "package.json", ".git", ".hg"]
	args = ["--stdio"]
	settings_section = "purescript"

	[purescript-language-server.settings.purescript]
	addSpagoSources = true
	addNpmPath = true
	formatter = "purs-tidy"
}

hook global WinSetOption filetype=purescript %{
	set-option buffer indentwidth 2
}
