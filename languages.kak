define-command -hidden -params 2 config-set-formatter %{
	evaluate-commands %sh{ echo "
		hook global WinSetOption \"filetype=$1\" %{
			set-option buffer formatcmd '$2'
			config-log \"filetype set to '$1'; using '%opt{formatcmd}' as formatter\"
			hook -once -always window WinSetOption filetype=.* %{
				config-log \"filetype changed; disabling '%opt{formatcmd}'\"
				unset-option buffer formatcmd
			}
		}
	" }
}

define-command -hidden -params 2 config-set-linter %{
	evaluate-commands %sh{ echo "
		hook global WinSetOption \"filetype=$1\" %{
			set-option buffer lintcmd '$2'
			config-log \"filetype set to '$1'; using '%opt{lintcmd}' as linter\"
			hook -once -always window WinSetOption filetype=.* %{
				config-log \"filetype changed; disabling '%opt{lintcmd}'\"
				unset-option buffer lintcmd
			}
		}
	" }
}

config-log "sourcing language files..."
evaluate-commands %sh{
	langsdir="languages"
	for f in "$kak_config/$langsdir"/*; do
		echo "config-try-source ${f##*"$kak_config"/}"
	done
}
config-log "finished sourcing language files"
