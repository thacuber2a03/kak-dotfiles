# kak-tree-sitter eats my highlighter and leaves me with nothing. and I don't know how to
# fix it or tell it to stop, so I'll just rehook back I guess

# TODO: see if this is a bug somehow ...or something

hook global WinSetOption filetype=csharp %<
	hook -once -always global NormalIdle .* %{ try %{
		# copied directly from mspielberg/csharp.kak with some changes
		add-highlighter window/csharp ref csharp
		hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/csharp }
	} }
>
