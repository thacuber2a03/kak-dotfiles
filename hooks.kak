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

hook global BufCreate '(.*/)?\.clangd' %{ set-option buffer filetype yaml }

require-module discord-rpc

define-command -params 0 -hidden config-update-discord-description %{
	set-option global discord_rpc_image_description "lole"
	set-option global discord_rpc_description "Editing %val{buffile} at %val{selections_desc}"
}

hook global NormalIdle .* config-update-discord-description
hook global InsertIdle .* config-update-discord-description
hook global InsertChar .* config-update-discord-description
hook global WinDisplay .* config-update-discord-description

