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

# in the rare case I use tmux
hook -once -always global ModuleLoaded tmux %{ alias global repl-new tmux-repl-vertical }

define-command -params 0 -hidden config-enable-reading-mode %{ try %{
	ui-line-numbers-disable
	ui-wrap-enable
	ui-whitespaces-disable
}}

hook global BufCreate (?:.*/)?\.clangd %{ set-option buffer filetype yaml }
hook global BufCreate .+\.ldtk         %{ set-option buffer filetype json }

# todo: collapse all of these hooks into one, somehow
hook global WinDisplay '\*stdin(?:-\d+)?\*' config-enable-reading-mode
hook global WinDisplay '\*man.+?\*'         config-enable-reading-mode
hook global WinDisplay '\*fifo\*'           config-enable-reading-mode
hook global WinDisplay '\*debug\*'          config-enable-reading-mode

hook -group auto-indent global InsertChar \t %{ try %{
	evaluate-commands %sh{ [ "$kak_opt_indentwidth" = 0 ] && printf %s "fail" }
	execute-keys -draft "h<a-h><a-k>\A\h+\z<ret><a-;>;%opt{indentwidth}@"
}}

hook -group auto-indent global InsertDelete ' ' %{ try %{
	execute-keys -draft 'h<a-h><a-k>\A\h+\z<ret>i<space><esc><lt>'
}}
