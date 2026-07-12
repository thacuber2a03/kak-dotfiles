provide-module jj-describe %§
	add-highlighter shared/jj-describe regions
	add-highlighter shared/jj-describe/comments region "^JJ:" $ group
	add-highlighter shared/jj-describe/comments/ fill comment
	add-highlighter shared/jj-describe/comments/ regex "\bChange ID: ([a-z])" 1:magenta
	# TODO
	add-highlighter shared/jj-describe/comments/ regex "\b(?:(M\N*)|(D\N*)|(A\N*))$" 1:blue 2:red 3:green
§

hook global BufCreate .+\.jjdescription %{
	set-option buffer filetype jj-describe
}

hook global WinSetOption filetype=jj-(describe) %{
	require-module "jj-%val{hook_param_capture_1}"
	add-highlighter "window/jj-%val{hook_param_capture_1}" ref "jj-%val{hook_param_capture_1}"
	hook -once -always window WinSetOption filetype=.* %exp{ remove-highlighter "window/jj-%val{hook_param_capture_1}" }
}
