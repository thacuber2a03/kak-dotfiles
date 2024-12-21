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

plug "andreyorst/smarttab.kak" \
	defer smarttab %{
		set-option global tabstop     4
		set-option global softtabstop 4
		set-option global indentwidth 4

		set-option global smarttab_expandtab_mode_name 'et'
		set-option global smarttab_noexpandtab_mode_name 'noet'
		set-option global smarttab_smarttab_mode_name 'smart'
	} config %{
		hook global BufOpenFile .* smarttab
		hook global BufNewFile  .* smarttab
	}

plug "andreyorst/powerline.kak" \
	defer powerline_default %{
		set-option global powerline_format 'git mode_info smarttab position line_column bufname filetype'
		powerline-separator triangle
	} defer powerline_bufname %{
		set-option global powerline_shorten_bufname 'short'
	} config 'powerline-start'

plug 'alexherbo2/auto-pairs.kak' \
	config %{ enable-auto-pairs }

plug 'delapouite/kakoune-text-objects'

plug 'https://gitlab.com/Screwtapello/kakoune-inc-dec' \
	config %{
		map -docstring "increment number under selection" global user a ': inc-dec-modify-numbers + %val{count}<ret>'
		map -docstring "decrement number under selection" global user x ': inc-dec-modify-numbers - %val{count}<ret>'
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

plug 'kkga/ui.kak' \
	config %{
		set-option global ui_line_numbers_flags \
			-separator '  ¦' \
			-hlcursor -cursor-separator ' <|' \
			-min-digits 3 -relative

		set-option global ui_whitespaces_flags -lf ' '

		hook global WinCreate .* %{
			ui-line-numbers-toggle
			# ui-whitespaces-toggle    # Kakoune issue 2654
			ui-trailing-spaces-toggle
			ui-matching-toggle
			ui-git-diff-toggle
			ui-todos-toggle
			# ui-lint-toggle # not sure about this one
		}

		hook global WinDisplay '\*.+?\*' %{ try %{ ui-wrap-enable } }
	}

plug 'thacuber2a03/forth.kak'

# ---------------------
# General configuration
# ---------------------

set-option global indentwidth 4
set-option global scrolloff 1,3

set-option      global ui_options terminal_status_on_top=true terminal_assistant=cat
set-option -add global ui_options terminal_padding_char=∙ terminal_padding_fill=true
# set-option -add global ui_options terminal_padding_char=

alias global x write-all-quit
define-command -docstring "source the current buffer" source-this %{ source "%val{buffile}" }
alias global . source-this

map -docstring "insert system clipboard"       global user P '!xsel --output --clipboard<ret>s\r<ret>d<c-o>'
map -docstring "append system clipboard"       global user p '<a-!>xsel --output --clipboard<ret>s\r<ret>d<c-o>'
map -docstring "replace with system clipboard" global user R '|xsel --output --clipboard<ret>s\r<ret>d<c-o>'
map -docstring "yank to system clipboard"      global user y '<a-|> xsel --input --clipboard <ret>'
map -docstring "search literally"              global user / ':exec /<ret>\Q\E<left><left>'

# handy function
map -docstring "for each selection, evaluate its expression and replace with result" global user = \
	': eval -itersel -save-regs dquote %{ set-register dquote %sh{ printf %s $(($kak_selection)) }; exec R }<ret>'

define-command -docstring "open a tutorial" -override trampoline %{
	evaluate-commands %sh{
		tramp_file=$(mktemp -t "kakoune-trampoline.XXXXXXXX")
		echo "edit -fifo $tramp_file *TRAMPOLINE*"
		curl -s https://raw.githubusercontent.com/mawww/kakoune/master/contrib/TRAMPOLINE -o "$tramp_file"
	}
}

# -----------
# Tree-sitter
# -----------

evaluate-commands %sh{ kak-tree-sitter -dks --init $kak_session }
try %{ colorscheme catppuccin_macchiato }

# ----------------
# Language servers
# ----------------

evaluate-commands %sh{ kak-lsp }
set-option global lsp_file_watch_support true
lsp-enable

lsp-inlay-hints-enable global
lsp-inlay-diagnostics-enable global
lsp-inlay-code-lenses-enable global

hook global BufSetOption filetype=.* %{ hook buffer BufWritePre .* lsp-formatting-sync }

map global user l "<a-;>: enter-user-mode lsp<ret>" -docstring "LSP mode"

map global insert <tab> \
	'<a-;>:try lsp-snippets-select-next-placeholders catch %{ execute-keys -with-hooks <lt>tab> }<ret>' \
	-docstring 'Select next snippet placeholder'

map global object a '<a-;>lsp-object<ret>'                               -docstring 'LSP any symbol'
map global object <a-a> '<a-;>lsp-object<ret>'                           -docstring 'LSP any symbol'
map global object f '<a-;>lsp-object Function Method<ret>'               -docstring 'LSP function or method'
map global object t '<a-;>lsp-object Class Interface Struct<ret>'        -docstring 'LSP class interface or struct'
map global object d '<a-;>lsp-diagnostic-object --include-warnings<ret>' -docstring 'LSP errors and warnings'
map global object D '<a-;>lsp-diagnostic-object<ret>'                    -docstring 'LSP errors'

hook -group lsp-filetype-c-family global BufSetOption filetype=(?:c|cpp|objc) %{
    set-option buffer lsp_servers %{
        [clangd]
        args = ["--log=error", "--fallback-style=Microsoft"]
        root_globs = ["compile_commands.json", ".clangd", ".git", ".hg"]
    }
}

hook -group lsp-filetype-lua global BufSetOption filetype=lua %{
	set-option buffer lsp_servers %{
		[lua-language-server]
		root_globs = [".git", ".hg"]
		settings_section = "Lua"

		[lua-language-server.settings.Lua]
		# diagnostics.enable = true

		[lua-language-server.settings.Lua.format.defaultConfig]
		indent_style = "tab"
		tab_width = "4"
		call_arg_parentheses = "remove"
		continuation_indent = "2"
		trailing_table_separator = "smart"
		space_around_table_append_operator = "false"
		align_call_args = "true"
		align_if_branch = "true"
		never_indent_before_if_condition = "true"
		line_space_after_function_statement = "max(2)"
		break_all_list_when_line_exceed = "true"
		auto_collapse_line = "true"
		end_statement_with_semicolon = "same_line"

		[lua-language-server.settings.Lua.completion]
		callSnippet = "Replace"
		displayContext = 5
		keywordSnippet = "Replace"

		[lua-language-server.settings.Lua.hover]
		expandAlias = false
	}
}
