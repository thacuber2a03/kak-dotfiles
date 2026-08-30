config-enable-default-lsp-support c

hook global BufOpenFile (.*/)?\.clang-format\z %{
	set-option buffer filetype yaml
}
