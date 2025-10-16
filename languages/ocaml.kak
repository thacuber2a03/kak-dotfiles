hook global WinSetOption filetype=ocaml %{
	set-option window indentwidth 2
	hook -group ocamlformat window BufWritePre %val{buffile} %{
		set-option window formatcmd "ocamlformat --name='%val{bufname}' -"
	}
	hook window BufSetOption filetype=.* %{
		remove-hooks window ocamlformat
	}
}
