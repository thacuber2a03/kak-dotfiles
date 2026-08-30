# kak-tree-sitter eats my highlighter and leaves me with nothing. and I don't know how to
# fix it or tell it to stop, so I'll just rehook back I guess

# TODO: see if this is a bug somehow ...or something

hook global WinSetOption filetype=haxe %<
	hook -once -always global NormalIdle .* %< try %<
		# copied directly from my own haxehl.kak with some changes
		add-highlighter window/haxe ref haxe
		hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/haxe }
	> >
>

config-enable-lsp-support haxe %{
	[haxe-language-server]
	command = "haxe-language-server"
	root_globs = [".git", "*.hxml", "*.hx"]
}
