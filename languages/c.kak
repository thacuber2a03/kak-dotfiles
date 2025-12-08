config-enable-default-lsp-support c

hook global BufOpenFile .*\.clang-format %{
	set-option buffer filetype yaml
}
