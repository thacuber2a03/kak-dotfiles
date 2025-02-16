hook global BufOpenFile .*\.clang-format %{
	set-option buffer filetype yaml
}
