hook global WinSetOption filetype=ruby %{
	set-option buffer indentwidth 2
	set-option buffer tabstop 8
}

config-set-formatter ruby 'rubocop --autocorrect --stderr --stdin .rb --fail-level F'
# config-set-linter ruby 'rubocop -f e --fail-level F'
