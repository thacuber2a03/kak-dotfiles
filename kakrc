hook global BufCreate (.*/)?\.kakrc %{ set-option buffer filetype kak }
set-option global source_local_kakrc true

hook global BufOpenFile .* smarttab
hook global BufNewFile  .* smarttab

hook global ModuleLoaded smarttab %{
    set-option global tabstop     4
    set-option global softtabstop 4
    set-option global indentwidth 4
}

enable-auto-pairs

# plug 'https://gitlab.com/Screwtapello/kakoune-inc-dec' \
# 	config %{
# 		map -docstring "increment number under selection" global user a ': inc-dec-modify-numbers + %val{count}<ret>'
# 		map -docstring "decrement number under selection" global user x ': inc-dec-modify-numbers - %val{count}<ret>'
# 	}

map -docstring "enter replace mode" global user r ': enter-user-mode replace<ret>'

set-option global ui_line_numbers_flags \
	-separator ' ¦ ' \
	-hlcursor -cursor-separator '<| ' \
	-min-digits 3 -relative

set-option global ui_whitespaces_flags -lf ' '

hook global WinCreate .* %{
	ui-line-numbers-toggle
	# ui-whitespaces-toggle    # Kakoune issue 2654
	ui-trailing-spaces-toggle
	ui-matching-toggle
	ui-git-diff-toggle
	ui-todos-toggle
}

hook global WinDisplay '\Q*debug*' %{ try %{ ui-wrap-enable } }

try %{ colorscheme catppuccin_macchiato }

set-option global scrolloff 1,3

set-option      global ui_options terminal_status_on_top=true terminal_assistant=cat
set-option -add global ui_options terminal_padding_char=∙ terminal_padding_fill=true
# set-option -add global ui_options terminal_padding_char=

alias global x write-all-quit

map -docstring "insert from system clipboard"  global user P '!cat /dev/clipboard<ret>s\r<ret>d<c-o>'
map -docstring "append from system clipboard"  global user p '<a-!>cat /dev/clipboard<ret>s\r<ret>d<c-o>'
map -docstring "yank to system clipboard"      global user y ': nop %sh{ printf %s "$kak_selections" > /dev/clipboard }<ret>'
map -docstring "replace with system clipboard" global user R '|cat /dev/clipboard<ret>s\r<ret>d<c-o>'
map -docstring "search literally"              global user / ': exec /<ret>\Q\E<left><left>'
