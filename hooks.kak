hook global BufSetOption filetype=     %{ set-option buffer filetype_info ""                                 }
hook global BufSetOption filetype=(.+) %{ set-option buffer filetype_info "(ft %val{hook_param_capture_1}) " }

### tooling

hook -group format-hook global BufWritePre .* 'try format catch lsp-formatting'

hook global BufSetOption lintcmd=.+ %{
	hook -group lint-hook buffer BufWritePre .* lint
	hook -once -always buffer BufSetOption lintcmd= %{ remove-hooks buffer lint-hook }
}

hook global BufCreate (?:.*/)?\.clangd 'set-option buffer filetype yaml'
hook global BufCreate .+\.ldtk         'set-option buffer filetype json'

hook global WinDisplay   \*.+?\*      'enable-reading-mode'
hook global WinSetOption filetype=man 'ui-wrap-disable'

hook global BufCreate .* 'try editorconfig-load'

# in the rare case I use tmux
hook -once -always global ModuleLoaded tmux %{ alias global repl-new tmux-repl-vertical }

define-command -hidden config-define-auto-indent-hooks -params 0 %{
	hook -group auto-indent global InsertChar \t %{ try %{
		evaluate-commands %sh{ [ "$kak_opt_indentwidth" = 0 ] && printf %s "fail" }
		execute-keys -draft "h<a-h><a-k>\A\h+\z<ret><a-;>;%opt{indentwidth}@"
	}}

	hook -group auto-indent global InsertDelete ' ' %{ try %{
		execute-keys -draft 'h<a-h><a-k>\A\h+\z<ret>i<space><esc><lt>'
	}}
}

config-define-auto-indent-hooks

# ~~this should be in plugins/kakoune-filetree.kak~~
# this straight up just doesn't work

# hook global RuntimeError "1:1: '(?:e|edit)': (.+): is a directory" %{
# 	try %{ filetree } catch %{ fail "could not open file tree: %val{error}" }
# }

# huh, removing hooks
if %opt{config_in_termux} %{
	remove-hooks lsp-filetype-.+
	remove-hooks lsp-semantic-tokens-.+
}
