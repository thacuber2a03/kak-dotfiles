set-option global tabstop     4
set-option global indentwidth 0
set-option global scrolloff   2,0

set-option global ui_options

set-option -add global ui_options \
	terminal_assistant=cat        \
	terminal_status_on_top=yes    \
	terminal_padding_fill=yes     \
	terminal_padding_char=.       \

evaluate-commands %sh{
	[ "$kak_opt_windowing_module" = kitty ] && exit

	# it's very likely that in 'wayland' I can't animate the cursor, sooooo
	if [ "$kak_opt_windowing_module" = wayland ]; then
		case "$kak_opt_termcmd" in
		foot*)
			exit
		esac
	fi

	printf %s\\n "set-option -add global ui_options terminal_cursor_native=yes"
}

set-option -add global ui_options terminal_set_title=yes

hook global WinDisplay .* %{ set-option -add global ui_options "terminal_title=%val{buffile}" }

set-option global autowrap_column 120
set-option global autowrap_format_paragraph true
set-option global writemethod replace

#############################################################################################################################################################################

declare-option str filetype_info

hook global BufSetOption filetype=     %{ set-option buffer filetype_info ""                                }
hook global BufSetOption filetype=(.+) %{ set-option buffer filetype_info "(ft %val{hook_param_capture_1}) " }

set-option global modelinefmt \
'{{context_info}} {{mode_info}} (%val{cursor_line}:%val{cursor_char_column}) │ %val{bufname} %opt{filetype_info}│ %val{client} [%val{session}] '

#############################################################################################################################################################################

if-not %opt{config_in_termux} %{
	set-option global windowing_placement window
	if %opt{config_in_niri} %{ set-option global windowing_module niri }
}

set-option global grepcmd 'rg --column'
# FIXME(thacuber2a03): something's odd
# try %{ set-option global termcmd 'ghostty -e' } catch %{ echo -debug "error: couldn't set termcmd (%val{error})" }
