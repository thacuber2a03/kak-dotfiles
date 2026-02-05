### tooling

hook -group format-hook global BufWritePre .* %{
	try format catch lsp-formatting catch ''
}

hook global BufSetOption lintcmd=.+ %{
	hook -group lint-hook buffer BufWritePre .* lint
	hook -once -always buffer BufSetOption lintcmd= %{ remove-hooks buffer lint-hook }
}

hook global BufCreate (?:.*/)?\.clangd 'set-option buffer filetype yaml'
hook global BufCreate .+\.ldtk         'set-option buffer filetype json'

hook global BufCreate .* %{ try %{ 
	execute-keys -draft <percent>s<c-v><esc><ret>
	ansi-enable
} }

hook global WinDisplay   \*.+?\*        enable-reading-mode
hook global WinSetOption filetype=man   ui-wrap-disable

# special case
# TODO(thacuber2a03): needed?
hook global WinDisplay \*stdin\* %{
	enable-reading-mode
	try %{ ui-wrap-disable }
}

define-command -hidden config-try-load-basic-tooling %{
	try modeline-parse catch editorconfig-load catch ''
}

hook global BufOpenFile .* config-try-load-basic-tooling
hook global BufNewFile .*  config-try-load-basic-tooling

# in the rare case I use tmux
hook -once -always global ModuleLoaded tmux %{
	set-option global windowing_placement vertical
}

define-command -hidden config-define-auto-indent-hooks %{
	hook -group auto-indent global InsertChar \t %{ try %{
		evaluate-commands %sh{ [ "$kak_opt_indentwidth" = 0 ] && printf %s "fail" }
		execute-keys -draft "h<a-h><a-k>\A\h+\z<ret><a-;>;%opt{indentwidth}@"
	}}

	hook -group auto-indent global InsertDelete ' ' %{ try %{
		execute-keys -draft 'h<a-h><a-k>\A\h+\z<ret>i<space><esc><lt>'
	}}
}

# conflicts with kak-lsp
# define-command -hidden config-define-auto-indent-hooks %{
# 	hook -group auto-indent global WinSetOption filetype=(?!makefile).* %{
# 		map global insert <tab> '<a-;><a-gt>'
# 		map global insert <s-tab> '<a-;><a-lt>'
# 	}
# }

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
