hook global BufSetOption formatcmd=.+ %{
	hook -group format-hook buffer BufWritePre .* format
	hook -once -always buffer BufSetOption formatcmd= %{
		remove-hooks buffer format-hook
	}
}

hook global BufSetOption lintcmd=.+ %{
	hook -group lint-hook buffer BufWritePre .* lint
	hook -once -always buffer BufSetOption lintcmd= %{
		remove-hooks buffer lint-hook
	}
}

# hook -once -always global ModuleLoaded tmux %{
# 	alias global repl-new tmux-repl-vertical
# }

define-command -params 0 -hidden config-enable-reading-mode %{
	ui-line-numbers-disable
	ui-wrap-enable
}

hook global BufCreate '(.*/)?\.clangd' 'set-option buffer filetype yaml'

hook global WinDisplay '\*stdin(?:-\d+)?\*' config-enable-reading-mode
hook global WinDisplay '\*man.+?\*'         config-enable-reading-mode

hook -group auto-indent global InsertChar \t %{
	try %{
		evaluate-commands %sh{ [ "$kak_opt_indentwidth" = 0 ] && printf %s "fail" }
		execute-keys -draft "h<a-h><a-k>\A\h+\z<ret><a-;>;%opt{indentwidth}@"
	}
}

hook -group auto-indent global InsertDelete ' ' %{ try %{
	execute-keys -draft 'h<a-h><a-k>\A\h+\z<ret>i<space><esc><lt>'
}}
