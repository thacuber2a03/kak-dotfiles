config-set-formatter ocaml 'ocamlformat --name=''%val{bufname}'' -'

hook global WinSetOption filetype=ocaml %{
	set-option window indentwidth 2
}
