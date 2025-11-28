provide-module zenlisp %§
	require-module lisp
§

hook global BufCreate .+\.zl %{ set-option buffer filetype zenlisp }

hook global WinSetOption filetype=zenlisp %{
	require-module zenlisp
	config-setup-lisp-mode
	hook -once -always window WinSetOption filetype=.* %{
	}
}
