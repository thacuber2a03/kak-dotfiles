set-option global ui_line_numbers_flags      \
    -relative -hlcursor -min-digits 3        \
    -separator '  |' -cursor-separator ' <|' \

map global user u ':enter-user-mode ui<ret>' -docstring "UI mode"

hook global WinCreate .* %{
	ui-line-numbers-toggle
	ui-cursorline-toggle
	ui-trailing-spaces-toggle
	ui-search-toggle
	ui-git-diff-toggle
}
