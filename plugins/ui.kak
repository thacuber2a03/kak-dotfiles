set-option global ui_line_numbers_flags      \
    -relative -hlcursor -min-digits 3        \
    -separator '  |' -cursor-separator ' <|' \

set-option global ui_wrap_flags -word -indent -marker '-'

map global user u ':enter-user-mode ui<ret>' -docstring "UI mode"

hook global WinCreate .* %{
	ui-line-numbers-toggle
	ui-whitespaces-toggle
	ui-cursorline-toggle
	ui-trailing-spaces-toggle
	ui-matching-toggle
	ui-search-toggle
	ui-git-diff-toggle
}
