provide-module config-umka %§
	define-command -docstring "
		umka-exported-names: grep all exported names in the project
	" umka-exported-names %{
		set-option local grepcmd 'grep -RHn'
		grep -E '\w+\*'
		try %{ delete-buffer! '*umka-exported-names*' }
		rename-buffer '*umka-exported-names*'
		hook -once -always buffer BufCloseFifo .* %{
			execute-keys -draft '%<a-s><a-k>(?:(?<lt>=grep: )umbox|^umbox|^box\.json|^\..*)<ret>d'
			add-highlighter buffer/ regex '\w+(?=\*)' 0:@MatchingChar
		}
	}
§

hook global WinSetOption filetype=umka %{
	require-module config-umka
}

# config-set-linter umka "%opt{config_current_source_directory}/umka-check.sh"
