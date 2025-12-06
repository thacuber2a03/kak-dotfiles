declare-option -hidden str config_ui_line_numbers_separator ' ▏'
declare-option -hidden str config_ui_line_numbers_cursor_separator ' 🯛'

if '%opt{config_in_termux}' %{
	set-option global config_ui_line_numbers_separator ' ▎'
	set-option global config_ui_line_numbers_cursor_separator ' ⟩'
}

try %{
	evaluate-commands %sh{ [ -n "$kak_opt_config_display_server" ] && printf %s fail }
	set-option global config_ui_line_numbers_separator ' |'
	set-option global config_ui_line_numbers_cursor_separator ' >'
}

set-option global ui_line_numbers_flags                             \
	-relative -hlcursor -min-digits 3                               \
	-separator %opt{config_ui_line_numbers_separator}               \
	-cursor-separator %opt{config_ui_line_numbers_cursor_separator}

set-option global ui_wrap_flags -word -marker '-'

set-option global ui_whitespaces_flags -lf '' -indent '▏'

map global user u ':enter-user-mode ui<ret>' -docstring "UI mode"

hook global WinCreate .* %{
	ui-line-numbers-enable
	ui-whitespaces-enable
	ui-todos-enable
	ui-cursorline-enable
	ui-trailing-spaces-enable
	ui-matching-enable
	ui-search-enable
	try ui-git-diff-enable # cheap way to solve this... but it works I guess
}
