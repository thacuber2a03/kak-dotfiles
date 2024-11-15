# -------
# Plugins
# -------

source "%val{config}/plugins/plug.kak/rc/plug.kak"
plug "andreyorst/plug.kak" noload

plug "dgmulf/local-kakrc" config %{ set-option global source_local_kakrc true }
hook global BufCreate (.*/)?\.kakrc %{ set-option buffer filetype kak }

plug "andreyorst/powerline.kak" \
	defer 'powerline_gruvbox' %{ powerline-theme palenight } \
	config %{ powerline-start }

plug "andreyorst/smarttab.kak" \
	defer 'smarttab' %{
		set-option global softtabstop 4
		set-option global smarttab_expandtab_mode_name 'et'
		set-option global smarttab_noexpandtab_mode_name 'noet'
	} config %{
		hook global BufOpenFile .* smarttab
		hook global BufNewFile .* smarttab
	}


plug 'alexherbo2/auto-pairs.kak' config %{ enable-auto-pairs }

# ---------------------
# General configuration
# ---------------------

colorscheme ayu-mirage

set-option global tabstop 4
set-option global indentwidth 4
set-option global scrolloff 1,3
set-option global autoinfo command|onkey

set-option global ui_options terminal_status_on_top=true terminal_assistant=cat
# set-option -add global ui_options terminal_padding_char=- terminal_padding_fill=true
set-option global ui_options terminal_padding_char=

add-highlighter -override global/my-numlines number-lines -hlcursor -relative -separator ' ¦ '
# add-highlighter -override global/my-trailspace regex \h+$ 0:Error
add-highlighter -override global/my-wordwrap wrap -word -indent
# add-highlighter -override global/my-matching show-matching
add-highlighter global/search ref search

map -docstring "yank the selection into the clipboard" global user y "<a-|> xsel -ib<ret>"
map -docstring "paste the clipboard" global user p "<a-!> xsel<ret>"

alias global x write-all-quit

# open tutor (needs curl)
define-command -override trampoline -docstring "open a tutorial" %{
	evaluate-commands %sh{
		tramp_file=$(mktemp -t "kakoune-trampoline.XXXXXXXX")
		echo "edit -fifo $tramp_file *TRAMPOLINE*"
		curl -s https://raw.githubusercontent.com/mawww/kakoune/master/contrib/TRAMPOLINE -o "$tramp_file"
	}
}

# ----------------
# Language servers
# ----------------

eval %sh{ kak-lsp }
set-option global lsp_file_watch_support true
lsp-enable

hook global BufSetOption filetype=.* %{ hook buffer BufWritePre .* lsp-formatting-sync }

map global user l %{ :enter-user-mode lsp<ret> } -docstring "LSP mode"

map global insert <tab> \
	'<a-;>:try lsp-snippets-select-next-placeholders catch %{ execute-keys -with-hooks <lt>tab> }<ret>' \
	-docstring 'Select next snippet placeholder'

map global insert <c-L> \
	'<a-;>:try lsp-snippets-select-next-placeholders<ret>' \
	-docstring 'Select next snippet placeholder'

map global object a '<a-;>lsp-object<ret>' -docstring 'LSP any symbol'
map global object <a-a> '<a-;>lsp-object<ret>' -docstring 'LSP any symbol'
map global object f '<a-;>lsp-object Function Method<ret>' -docstring 'LSP function or method'
map global object t '<a-;>lsp-object Class Interface Struct<ret>' -docstring 'LSP class interface or struct'
map global object d '<a-;>lsp-diagnostic-object --include-warnings<ret>' -docstring 'LSP errors and warnings'
map global object D '<a-;>lsp-diagnostic-object<ret>' -docstring 'LSP errors'

# -----------
# Tree-sitter
# -----------

eval %sh{ kak-tree-sitter -dks --init $kak_session }

# --------
# Epilogue
# --------

# these lines, and autoload/splash.kak, were taken from https://github.com/alexherbo2/dotfiles

hook -once global ClientCreate ".*" %{
	try %{
		evaluate-commands -buffer "*scratch*" ""
		show_splash_screen
	}
}

define-command open_kakrc %{ edit "%val{config}/kakrc" }
