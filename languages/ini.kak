hook global BufCreate .+/\.config/(?:ghostty|swaylock)/config %{
	set-option buffer filetype ini
}
