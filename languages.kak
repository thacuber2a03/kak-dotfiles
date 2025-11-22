define-command -docstring "
	config-set-formatter <filetype> <command> : generates a hook
	that sets/unsets `formatcmd` to <command> for some <filetype>
" -hidden -params 2 config-set-formatter %{
	evaluate-commands %sh{ echo "
		hook global WinSetOption \"filetype=$1\" %{
			set-option buffer formatcmd '$2'
			config-log \"filetype set to '$1;' using '%opt{formatcmd}' as formatter\"
			hook -once -always window WinSetOption filetype=.* %{
				config-log \"filetype 'changed;' disabling '%opt{formatcmd}'\"
				unset-option buffer formatcmd
			}
		}
	" }
}

define-command -docstring "
	config-set-linter <filetype> <command> : generates a hook
	that sets/unsets `lintcmd` to <command> for some <filetype>
" -hidden -params 2 config-set-linter %{
	evaluate-commands %sh{ echo "
		hook global WinSetOption \"filetype=$1\" %{
			set-option buffer lintcmd '$2'
			config-log \"filetype set to '$1;' using '%opt{lintcmd}' as linter\"
			hook -once -always window WinSetOption filetype=.* %{
				config-log \"filetype 'changed;' disabling '%opt{lintcmd}'\"
				unset-option buffer lintcmd
			}
		}
	" }
}

config-try-source-directory 'languages'
