declare-option -hidden str config_ui_line_numbers_separator
declare-option -hidden str config_ui_line_numbers_cursor_separator

try %{
	evaluate-commands %sh{
		if [ "$kak_opt_config_os" = Android ] \
		|| [ -z "$kak_opt_config_display_server" ]
		then
			printf %s fail
		fi
	}
	# ▎
	# ▏
	# 🮌
	set-option global config_ui_line_numbers_separator ' 🮌'
	set-option global config_ui_line_numbers_cursor_separator ' ⟩'
} catch %{
	set-option global config_ui_line_numbers_separator '|'
	set-option global config_ui_line_numbers_cursor_separator '>'
}

set-option global ui_line_numbers_flags                             \
	-relative -hlcursor -min-digits 3                               \
	-separator %opt{config_ui_line_numbers_separator}               \
	-cursor-separator %opt{config_ui_line_numbers_cursor_separator}

set-option global ui_wrap_flags -word -marker '-'

map global user u ':enter-user-mode ui<ret>' -docstring "UI mode"

hook global WinCreate .* %{
	ui-line-numbers-toggle
	ui-whitespaces-toggle
	ui-todos-toggle
	ui-cursorline-toggle
	ui-trailing-spaces-toggle
	ui-matching-toggle
	ui-search-toggle
	ui-git-diff-toggle
}
