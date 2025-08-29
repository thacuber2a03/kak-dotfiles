try %{
	evaluate-commands %sh{ [ "$kak_opt_config_display_server" != "X11" ] && printf %s fail }

	# FIX(thacuber2a03): ruined this a bit for Windows for the time being
	# Windows likes to do a funny, even in WSL, and pastes in the \rs as well,
	# so the extra keys that came after were a hack to fix *that*
	#
	# now that I'm on Linux, I couldn't care less, but I don't want to
	# completely remove the convenience for others
	map global user d '|xsel -ib<ret>'      -docstring "delete to system clipboard"
	map global user y '<a-|>xsel -ib<ret>'  -docstring "yank to system clipboard"
	map global user P '!xsel -ob<ret>'      -docstring "insert from system clipboard"
	map global user p '<a-!>xsel -ob<ret>'  -docstring "append from system clipboard"
	map global user R '|xsel -ob<ret>'      -docstring "replace with system clipboard"
} catch %{
	evaluate-commands %sh{ [ "$kak_opt_config_display_server" != "Wayland" ] && printf %s fail }
	# huh, wayland has it shorter
	map global user d '|wl-copy -n<ret>'     -docstring "delete to system clipboard"
	map global user y '<a-|>wl-copy -n<ret>' -docstring "yank to system clipboard"
	map global user P '!wl-paste<ret>'       -docstring "insert from system clipboard"
	map global user p '<a-!>wl-paste<ret>'   -docstring "append from system clipboard"
	map global user R '|wl-paste<ret>'       -docstring "replace with system clipboard"
} catch %{
	config-log "unknown or unsupported environment, system copy/paste commands disabled"
}

map global user / '/\Q\E<left><left>' -docstring "search literally"

map global normal <c-p> vk
map global normal <c-n> vj

# undocumented mappings as of master: soft-wrapping j and k
map global normal j gd
map global normal k gu
