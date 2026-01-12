bundle-install-hook kak-rainbower %exp{
	path="%val{config}/bundle/kak-rainbower/rc/rainbower"
	c++ "$path.cpp" -o "$path"
}

define-command -docstring "
	rainbow-toggle-window: toggle rainbow parentheses for this window
" rainbow-toggle-window %{
	try %{ rainbow-disable-window } catch %{ rainbow-enable-window }
}

# yeah, somehow I've not overrriden <space>r yet
map global user r ':rainbow-toggle-window<ret>' -docstring 'toggle rainbow parentheses for this window'
