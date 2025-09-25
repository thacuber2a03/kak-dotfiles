hook global WinSetOption filetype=markdown %{
	ui-wrap-enable

	# open local markdown link (does not work for links with hashes)
	hook window NormalKey <ret> %{ try %{
		evaluate-commands -draft %{
			execute-keys \
				:encapsul8-action<ret> pi y \
				<a-k>\A[./\w-]+<ret> \
				:e<space><c-r>"<ret>
		}
		# ok, so this works, but *just* because the buffer opens in front of the current one
		execute-keys :bn<ret>
	} }
}

# [example configuration](./examples/eww-bar/eww.yuck) askdhaksdhaksjdhaksd [example configuration](./examples/eww-bar/eww.yuck) akjshdkashdkashdkashda
