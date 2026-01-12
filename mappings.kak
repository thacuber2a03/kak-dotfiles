declare-option bool config_system_clipboard false

if %opt{config_in_termux} %{
	map -docstring "delete to system clipboard"    global user d '<a-|>termux-clipboard-set<ret><a-d>'
	map -docstring "yank to system clipboard"      global user y '<a-|>termux-clipboard-set<ret>'
	map -docstring "insert from system clipboard"  global user P '!termux-clipboard-get<ret>'
	map -docstring "append from system clipboard"  global user p '<a-!>termux-clipboard-get<ret>'
	map -docstring "replace with system clipboard" global user R '|termux-clipboard-get<ret>'
	set-option global config_system_clipboard true
}

if %opt{config_in_x11} %{
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
	set-option global config_system_clipboard true
}

if %opt{config_in_wayland} %{
	# ~~huh, wayland has it shorter~~ nevermind anymore
	map -docstring "delete to system clipboard"    global user d '<a-|>wl-copy -n<ret><a-d>'
	map -docstring "yank to system clipboard"      global user y '<a-|>wl-copy -n<ret>'
	map -docstring "insert from system clipboard"  global user P '!wl-paste -n<ret>'
	map -docstring "append from system clipboard"  global user p '<a-!>wl-paste -n<ret>'
	map -docstring "replace with system clipboard" global user R '|wl-paste -n<ret>'
	set-option global config_system_clipboard true
}

if-not %opt{config_system_clipboard} %{
	config-log info "unknown or unsupported environment, system copy/paste commands disabled"
}

map global user / '/\Q\E<left><left>' -docstring "search literally"

# move view with Ctrl-p/n rather than vk/j
# idea ~~stolen~~ borrowed from https://ficd.sh
map global normal <c-p> vk
map global normal <c-n> vj

# times where it's nice to center the screen
map global normal n nvc
map global normal N Nvc
map global normal <a-n> <a-n>vc
map global normal <a-N> <a-N>vc
map global normal ( (vc
map global normal ) )vc
map global normal <a-(> <a-(>vc
map global normal <a-)> <a-)>vc

# undocumented mappings as of master: soft-wrapping j and k
# NOTE(thacuber2a03): they are still somewhat uncooked, so...
# map global normal j gd
# map global normal k gu

declare-user-mode project
map -docstring 'enter project mode' global user <space> ':enter-user-mode project<ret>'
