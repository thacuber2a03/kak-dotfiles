try %{
	evaluate-commands %sh{ [ "$kak_opt_config_os" != "Android" ] && printf %s fail }

	map -docstring "delete to system clipboard"    global user d '<a-|>termux-clipboard-set<ret>d'
	map -docstring "yank to system clipboard"      global user y '<a-|>termux-clipboard-set<ret>'
	map -docstring "insert from system clipboard"  global user P '!termux-clipboard-get<ret>'
	map -docstring "append from system clipboard"  global user p '<a-!>termux-clipboard-get<ret>'
	map -docstring "replace with system clipboard" global user R '|termux-clipboard-get<ret>'
} catch %{
	evaluate-commands %sh{ [ "$kak_opt_config_display_server" != "X11" ] && printf %s fail }

	# FIX(thacuber2a03): ruined this a bit for Windows for the time being
	# Windows likes to do a funny, even in WSL, and pastes in the \rs as well,
	# so the extra keys that came after were a hack to fix *that*
	#
	# now that I'm on Linux, I couldn't care less, but I don't want to
	# completely remove the convenience for others
	map -docstring "delete to system clipboard"    global user d '|xsel -ib<ret>'
	map -docstring "yank to system clipboard"      global user y '<a-|>xsel -ib<ret>'
	map -docstring "insert from system clipboard"  global user P '!xsel -ob<ret>'
	map -docstring "append from system clipboard"  global user p '<a-!>xsel -ob<ret>'
	map -docstring "replace with system clipboard" global user R '|xsel -ob<ret>'
} catch %{
	evaluate-commands %sh{ [ "$kak_opt_config_display_server" != "Wayland" ] && printf %s fail }
	# ~~huh, wayland has it shorter~~ nevermind anymore
	map -docstring "delete to system clipboard"    global user d '<a-|>wl-copy -n<ret><a-d>'
	map -docstring "yank to system clipboard"      global user y '<a-|>wl-copy -n<ret>'
	map -docstring "insert from system clipboard"  global user P '!wl-paste<ret>'
	map -docstring "append from system clipboard"  global user p '<a-!>wl-paste<ret>'
	map -docstring "replace with system clipboard" global user R '|wl-paste<ret>'
} catch %{
	config-log "unknown or unsupported environment, system copy/paste commands disabled"
}

map global user / '/\Q\E<left><left>' -docstring "search literally"

map global normal <c-p> vk
map global normal <c-n> vj

# undocumented mappings as of master: soft-wrapping j and k
map global normal j gd
map global normal k gu
