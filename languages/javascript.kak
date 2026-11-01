config-enable-lsp-support javascript %{
	[deno]
	root_globs = ["package.json", "tsconfig.json", ".git", ".hg"]
	args = ["lsp"]
	settings_section = "deno"
	[deno.settings.deno]
	enable = true
	lint = true
}
