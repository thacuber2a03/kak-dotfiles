hook global BufOpenFile .*\.clang-format %{
	set-option buffer filetype yaml
}

hook global WinSetOption filetype=c %{ lsp-enable-window }
