bundle-install-hook kakeidoscope %{ cargo install kakeidoscope }
bundle-cleaner kakeidoscope %{ cargo uninstall kakeidoscope }

try 'evaluate-commands %sh{ kakeidoscope init }'

define-command -docstring "
	kakeidoscope-toggle-window: toggle kakeidoscope at window scope
" kakeidoscope-toggle-window %{
	try kakeidoscope-enable-window catch kakeidoscope-disable-window
}

# yeah, somehow I've not overrriden <space>r yet
map global user r ':kakeidoscope-toggle-window<ret>' -docstring 'toggle rainbow parentheses for this window'
