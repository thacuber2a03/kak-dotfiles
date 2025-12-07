define-command -hidden -docstring "
	config-set-formatter <filetype> <command> : generates a hook
	that sets/unsets `formatcmd` to <command> for some <filetype>
" config-set-formatter -params 2 %{
	hook global BufSetOption "filetype=%arg{1}" %exp{
		set-option buffer formatcmd "%arg{2}"
		config-log info "%%val{bufname}: filetype set to %arg{1}, using '%%opt{formatcmd}' as formatter"
		hook -once -always buffer BufSetOption filetype=.* %%{
			config-log info "%%val{bufname}: filetype changed, disabling '%%opt{formatcmd}'"
			unset-option buffer formatcmd
		}
	}
}

define-command -hidden -docstring "
	config-set-linter <filetype> <command> : generates a hook
	that sets/unsets `lintcmd` to <command> for some <filetype>
" config-set-linter -params 2 %{
	hook global BufSetOption "filetype=%arg{1}" %exp{
		set-option buffer lintcmd "%arg{2}"
		config-log info "%%val{bufname}: filetype set to %arg{1}, using '%%opt{lintcmd}' as linter"
		hook -once -always buffer BufSetOption filetype=.* %%{
			config-log info "%%val{bufname}: filetype changed, disabling '%%opt{lintcmd}'"
			unset-option buffer lintcmd
		}
	}
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

	hook -once -always window WinSetOption filetype=.* %{
		remove-hooks buffer parinfer
		set-option -remove window ui_whitespaces_flags -spc ' ' -tab '�' -tabpad '�'
		unset-option buffer indentwidth
		unset-option buffer tabstop
		config-define-auto-indent-hooks
	}
}

define-command -hidden config-enable-default-lsp-support -params 1 %{
	if-not %opt{config_in_termux} %exp{
		hook -always global WinSetOption filetype=%arg{1} 'lsp-enable-window'
	}
}

define-command -hidden config-enable-lsp-support -params 2 %{
	config-enable-default-lsp-support %arg{1}

	if-not %opt{config_in_termux} %exp{
		hook -group lsp-filetype-%arg{1} global BufSetOption filetype=%arg{1} %%{
			set-option buffer lsp_servers "%arg{2}"
		}
	}
}

define-command -hidden config-enable-tree-sitter-support -params 1 %{
	if-not %opt{config_in_termux} %exp{
		hook -once -always global WinSetOption filetype=%arg{1} %%{
			evaluate-commands %%sh{ kak-tree-sitter -dks --init $kak_session }
		}
	}
}

define-command -hidden config-enable-default-lsp-and-ts -params 1 %{
	config-enable-tree-sitter-support %arg{1}
	config-enable-default-lsp-support %arg{1}
}

define-command -hidden config-enable-lsp-and-ts -params 2 %{
	config-enable-tree-sitter-support %arg{1}
	config-enable-lsp-support         %arg{@}
}

config-try-source-directory 'languages'
