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

hook -once -always global ModuleLoaded tmux %{
	alias global repl-new tmux-repl-vertical
}

hook global BufCreate '\*stdin(?:-\d+)?\*' %{ set-option buffer readonly true }

hook global BufCreate '\.clangd' %{ set-option buffer filetype yaml }
