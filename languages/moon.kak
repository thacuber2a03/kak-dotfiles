config-set-linter moon "moon %opt{config_current_source_directory}/mlint.moon"

provide-module config-moon %§
	define-command -docstring "
		moon-preview <buffer>: compiles the moon code at <buffer> in a separate, scratch buffer;
		uses the current buffer if <buffer> is unspecified
	" moon-preview -params 0..1 %{
		evaluate-commands -save-regs 'a' %{
			set-register a %val{buffile}
			evaluate-commands %sh{ [ -n "$1" ] && printf %s "set-register a '$1'" }
			fifo -name '*moon*' moonc -p %reg{a}
			set-option buffer filetype lua
		}
	}

	complete-command moon-preview file 1
§

hook global WinSetOption filetype=moon 'require-module config-moon'
