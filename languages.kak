define-command -hidden -docstring "
	config-set-formatter <filetype> <command> : generates a hook
	that sets/unsets `formatcmd` to <command> for some <filetype>
" config-set-formatter -params 2 %{
	evaluate-commands %sh{ echo "
		hook global BufSetOption filetype=$1 %{
			set-option buffer formatcmd '$2'
			config-log \"%val{bufname}: filetype set to $1, using '%opt{formatcmd}' as formatter\"
			hook -once -always buffer BufSetOption filetype=.* %{
				config-log \"%val{bufname}: filetype changed, disabling '%opt{formatcmd}'\"
				unset-option buffer formatcmd
			}
		}
	" }
}

define-command -hidden -docstring "
	config-set-linter <filetype> <command> : generates a hook
	that sets/unsets `lintcmd` to <command> for some <filetype>
" config-set-linter -params 2 %{
	evaluate-commands %sh{ echo "
		hook global BufSetOption filetype=$1 %{
			set-option buffer lintcmd '$2'
			config-log \"%val{bufname}: filetype set to $1, using '%opt{lintcmd}' as linter\"
			hook -once -always buffer BufSetOption filetype=.* %{
				config-log \"%val{bufname}: filetype changed, disabling '%opt{lintcmd}'\"
				unset-option buffer lintcmd
			}
		}
	" }
}

define-command -hidden config-setup-lisp-mode %{
	set-option buffer indentwidth 2
	set-option buffer tabstop 8

	set-option -add window ui_whitespaces_flags -spc ' ' -tab '�' -tabpad '�'
	ui-whitespaces-toggle
	ui-whitespaces-toggle

	remove-hooks global auto-indent

	try 'parinfer-enable-window -smart' catch %{
		hook -group parinfer buffer BufWritePre .* parinfer
	}

	hook -once -always buffer BufSetOption filetype=.* %{
		remove-hooks buffer parinfer
		set-option -remove window ui_whitespaces_flags -spc ' ' -tab '�' -tabpad '�'
		unset-option buffer indentwidth
		unset-option buffer tabstop
		config-define-auto-indent-hooks
	}
}

config-try-source-directory 'languages'
