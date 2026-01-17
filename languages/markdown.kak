hook global WinSetOption filetype=markdown %{
	enable-reading-mode
	# open local markdown link (does not work for links with hashes)
	# hook window NormalKey <ret> %{ 
	# 	evaluate-commands -save-regs '/"' %{
	# 		try %{
	# 			execute-keys -save-regs '' \
	# 				:encapsul8-action<ret> pi y \
	# 				<a-k>\A[./\w-]+<ret> \
	# 				:e<space><c-r>"<ret>
	# 			set-option buffer filetype markdown
	# 		}
	# 	}
	# }
}
