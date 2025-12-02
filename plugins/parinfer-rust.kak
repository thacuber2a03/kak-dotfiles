bundle-install-hook parinfer-rust %{ cargo install --force --path . }
bundle-cleaner      parinfer-rust %{ cargo uninstall parinfer-rust }

declare-option -docstring "
	Extra flags to pass to the parinfer-rust binary
" str-list parinfer_extra_flags

# FIXME(thacuber2a03): overriding a whole command like this is really stupid, but ok
define-command -override -docstring "parinfer [<switches>]: reformat buffer with parinfer-rust.
Switches:
	-if-enabled  Check 'parinfer_enabled' option before applying changes.
	-indent      Preserve indentation and fix parentheses (default).
	-paren       Preserve parentheses and fix indentation.
	-smart       Try to be smart about what to fix." \
parinfer -params ..2 %{
	evaluate-commands -draft -save-regs '/"|^@' -no-hooks %{
		set buffer parinfer_cursor_char_column %val{cursor_char_column}
		set buffer parinfer_cursor_line %val{cursor_line}
		execute-keys '\%'
		evaluate-commands -draft -no-hooks %sh{
			mode=indent
			while [ $# -ne 0 ]; do
				case "$1" in
					-if-enabled) [ "$kak_opt_parinfer_enabled" = "true" ] || exit 0;;
					-smart)  mode=smart;;
					-paren)  mode=paren;;
					-indent) mode=indent;;
					*)       printf "fail %%{unknown switch '%s'}\n" "$1"
					         exit;;
				esac
				shift
			done
			export mode
			if [ -z "${kak_opt_parinfer_previous_timestamp}" ]; then
				export kak_opt_parinfer_previous_text="${kak_selection}"
				export kak_opt_parinfer_previous_cursor_char_column="${kak_opt_parinfer_cursor_char_column}"
				export kak_opt_parinfer_previous_cursor_line="${kak_opt_parinfer_cursor_line}"
			elif [ "$mode" = smart ] &&
				 [ "${kak_opt_parinfer_previous_timestamp}" = "$kak_timestamp" ]; then
				exit 0
			fi
			if [ "${kak_opt_parinfer_select_switches}" = unknown ]; then
				if [ -n "${kak_selections_display_column_desc}" ]; then
					export kak_opt_parinfer_select_switches='-display-column'
				else
					export kak_opt_parinfer_select_switches=''
				fi
				printf 'set-option global parinfer_select_switches "%s"\n' "$kak_opt_parinfer_select_switches"
			fi
			# VARIABLES USED:
			# kak_opt_filetype,
			# kak_opt_parinfer_cursor_char_column,
			# kak_opt_parinfer_cursor_line,
			# kak_opt_parinfer_previous_text,
			# kak_opt_parinfer_previous_cursor_char_column,
			# kak_opt_parinfer_previous_cursor_line,
			# kak_opt_parinfer_select_switches,
			# kak_selection
			exec "$kak_opt_parinfer_path" --mode=$mode --input-format=kakoune --output-format=kakoune $kak_opt_parinfer_extra_flags
		}
		evaluate-commands %{
			set-option buffer parinfer_previous_text %val{selection}
			set-option buffer parinfer_previous_timestamp %val{timestamp}
			set-option buffer parinfer_previous_cursor_char_column %val{cursor_char_column}
			set-option buffer parinfer_previous_cursor_line %val{cursor_line}
		}
	}
	evaluate-commands %sh{
		line=$kak_opt_parinfer_cursor_line
		column=$kak_opt_parinfer_cursor_char_column
		if [ -n "$kak_selections_display_column_desc" ]; then
			set -- $kak_selections_display_column_desc
		else
			set -- $kak_selections_desc
		fi
		case "$1" in
			*,${line}.${column}) exit;;
		esac
		shift
		echo "select ${kak_opt_parinfer_select_switches} ${line}.${column},${line}.${column} $@"
	}
}
