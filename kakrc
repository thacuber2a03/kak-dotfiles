# -------
# Plugins
# -------

evaluate-commands %sh{
    plugins="$kak_config/plugins"
    mkdir -p "$plugins"
    [ ! -e "$plugins/plug.kak" ] && \
        git clone -q https://github.com/andreyorst/plug.kak.git "$plugins/plug.kak"
    printf "%s\n" "source '$plugins/plug.kak/rc/plug.kak'"
}
plug "andreyorst/plug.kak" noload

plug "dgmulf/local-kakrc" \
	config %{
		set-option global source_local_kakrc true
		hook global BufCreate (.*/)?\.kakrc %{ set-option buffer filetype kak }
	}

plug "andreyorst/powerline.kak" \
	config %{ powerline-start }

plug "andreyorst/smarttab.kak" \
	defer 'smarttab' %{ set-option global softtabstop 4 } \
	config %{
		hook global BufOpenFile .* smarttab
		hook global BufNewFile .* smarttab
	}

plug 'alexherbo2/auto-pairs.kak' \
	config %{ enable-auto-pairs }

plug 'delapouite/kakoune-text-objects'

plug 'https://gitlab.com/Screwtapello/kakoune-inc-dec' \
	config %{
		map -docstring "increment number under selection" \
			global user a ': inc-dec-modify-numbers + %val{count}<ret>'
		map -docstring "decrement number under selection" \
			global user x ': inc-dec-modify-numbers - %val{count}<ret>'
	}

plug "eraserhd/parinfer-rust" \
	do %{ cargo install --force --path . } \
	config %{
	    hook global WinSetOption filetype=(clojure|lisp|scheme|racket) \
	    	%{ parinfer-enable-window -smart }
	}

plug 'gustavo-hms/luar' \
	config %{ require-module luar }

plug 'tomKPZ/replace-mode.kak' \
	config %{
		map -docstring "enter replace mode" \
			global user r ': enter-user-mode replace<ret>'
	}

plug 'caksoylar/kakoune-focus' \
	config %{
		map -docstring "toggle selections focus" \
			global user <space> ": focus-toggle<ret>"
		define-command focus-live-enable %{
		    focus-selections
		    hook -group focus window NormalIdle .* %{ focus-extend }
		}
		define-command focus-live-disable %{
		    remove-hooks window focus
		    focus-clear
		}
	}

# ---------------------
# General configuration
# ---------------------

colorscheme berry

set-option global tabstop 4
set-option global indentwidth 4
set-option global scrolloff 1,3
set-option global autoinfo command|onkey

set-option global ui_options terminal_status_on_top=true terminal_assistant=cat
# set-option -add global ui_options terminal_padding_char=- terminal_padding_fill=true
set-option -add global ui_options terminal_padding_char=

add-highlighter -override global/my-numlines number-lines \
	-relative -separator        ' ¦  ' \
	-hlcursor -cursor-separator ' ¦❱ '

# add-highlighter -override global/my-trailspace regex \h+$ 0:Error
# add-highlighter -override global/my-wordwrap wrap -word -indent
# add-highlighter -override global/my-matching show-matching
add-highlighter -override global/search ref search

alias global x write-all-quit

map -docstring "insert contents of system clipboard" global user P '!xsel --output --clipboard<ret>'
map -docstring "append contents of system clipboard" global user p '<a-!>xsel --output --clipboard<ret>'
map -docstring "yank to system clipboard" global user y '<a-|> xsel --input --clipboard <ret>'
map -docstring "replace with contents of system clipboard" global user R '|xsel --output --clipboard<ret>'

# handy function
# TODO: replace selections with result somehow
map -docstring "for each selection, evaluate its expression and replace with result" global user = \
	':eval -itersel -save-regs dquote %{ set-register dquote %sh{ printf %s $(($kak_selection)) }; exec R }<ret>'

define-command -docstring "open a tutorial" -override trampoline %{
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

map global user l "<a-;>:enter-user-mode lsp<ret>" -docstring "LSP mode"

map global insert <tab> \
	'<a-;>:try lsp-snippets-select-next-placeholders catch %{ execute-keys -with-hooks <lt>tab> }<ret>' \
	-docstring 'Select next snippet placeholder'

map global object a '<a-;>lsp-object<ret>' -docstring 'LSP any symbol'
map global object <a-a> '<a-;>lsp-object<ret>' -docstring 'LSP any symbol'
map global object f '<a-;>lsp-object Function Method<ret>' -docstring 'LSP function or method'
map global object t '<a-;>lsp-object Class Interface Struct<ret>' -docstring 'LSP class interface or struct'
map global object d '<a-;>lsp-diagnostic-object --include-warnings<ret>' -docstring 'LSP errors and warnings'
map global object D '<a-;>lsp-diagnostic-object<ret>' -docstring 'LSP errors'
