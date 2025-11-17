set-option global tabstop     4
set-option global indentwidth 0
set-option global scrolloff   2,0

set-option global ui_options

set-option -add global ui_options \
	terminal_assistant=cat        \
	terminal_status_on_top=yes    \
	terminal_padding_fill=yes     \
	terminal_padding_char=.       \
	terminal_synchronized=yes

set-option -add global ui_options terminal_set_title=yes
hook global WinDisplay .* %{ set-option -add global ui_options "terminal_title=%val{buffile}" }

set-option global autowrap_column 120
set-option global autowrap_format_paragraph true

#############################################################################################################################################################################

# this is option related, but has a hook in it as well...

declare-option str filetype_info

hook global BufSetOption filetype=     %{ set-option buffer filetype_info ""                                 }
hook global BufSetOption filetype=(.+) %{ set-option buffer filetype_info "(ft %val{hook_param_capture_1}) " }

set-option global modelinefmt \
'%val{bufname} %opt{filetype_info}%val{cursor_line}:%val{cursor_char_column} {{context_info}} {{mode_info}} - %val{client}@[%val{session}]'

#############################################################################################################################################################################

if-not %opt{config_in_termux} %{
	try %{
		evaluate-commands %sh{ [ -s "$NIRI_SOCKET" ] && printf %s\\n fail }
		set-option global windowing_module 'niri'
		# the niri window module doesn't *technically* support splits other than window
		set-option global windowing_placement 'window'
	} catch %{
		set-option global windowing_placement %sh{
			[ "$kak_opt_config_display_server" = "Wayland" ] && printf %s 'window' || printf %s 'vertical'
		}
	}
}

#############################################################################################################################################################################

# are colorschemes options?
evaluate-commands %sh{
	if [ -n "$kak_opt_config_display_server" ]; then
		printf %s\\n "colorscheme ashen"
		printf %s\\n "hook global WinCreate .* 'set-face global LineNumberCursor LineNumbers'"
	fi
}
