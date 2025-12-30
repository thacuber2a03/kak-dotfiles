evaluate-commands %sh{
	bundledir="$kak_config/bundle"

	if [ ! -d "$bundledir/kak-bundle" ]; then
		if ! git clone "https://codeberg.org/jdugan6240/kak-bundle" "$bundledir/kak-bundle"; then
			echo "config-fail 'couldn''t install bundle; stopping'"
		fi
	fi

	if [ -f "$bundledir/kak-bundle/rc/kak-bundle.kak" ]; then
		echo "
			source '$bundledir/kak-bundle/rc/kak-bundle.kak'
			bundle-noload kak-bundle 'https://codeberg.org/jdugan6240/kak-bundle'
		"
	else
		echo "config-fail 'kak-bundle.kak not found; stopping'"
	fi
}

define-command -hidden config-add-theme -params .. %{
	config-log trace "adding colorscheme '%arg{1}'"
	bundle-theme %arg{1} %arg{2}
	# I'd make a command for this but then what the `local` scope refers to effs up
	set-option local config_current_source_directory "%opt{config_current_source_directory}/plugins"
	config-try-source "%arg{1}"
}

# loaded plugins. format: `name (url)`
declare-option -hidden str-list config_plugins

define-command -hidden config-add-plugin -params .. %{
	config-log trace "registering plugin '%arg{1}'"
	set-option -add global config_plugins "%arg{1} (%arg{2})"
	bundle %arg{1} %arg{2} %exp{
		# ditto
		set-option local config_current_source_directory "%opt{config_current_source_directory}/plugins"
		config-try-source "%arg{1}"
	}
}

define-command -hidden config-add-custom-plugin -params .. %{
	config-log trace "registering plugin '%arg{1}' (custom load)"
	set-option -add global config_plugins "%arg{1} (%arg{2})"
	bundle-customload %arg{1} %arg{2} %exp{
		# ditto
		set-option local config_current_source_directory "%opt{config_current_source_directory}/plugins"
		config-try-source "%arg{1}"
	}
}

define-command -docstring "
	config-show-plugins: opens a new buffer showing all installed plugins
" config-show-plugins %{
	edit! -scratch '*plugins*'

	add-highlighter buffer/ regex 'Installed plugins:' 0:header

	evaluate-commands -draft %{
		execute-keys i 'Installed plugins:' <ret><ret> <esc>
		evaluate-commands %sh{
			printf %s 'execute-keys i '
			eval set -- "$kak_quoted_opt_config_plugins"
			while [ $# -gt 0 ]; do
				printf %s "'- $1<ret>' "
				shift
			done
			printf %s\\n '<esc>'
		}
		execute-keys <a-i>p s\(<ret> &
	}
}

config-add-plugin ui                  'https://github.com/kkga/ui.kak'
config-add-plugin Encapsul8           'https://github.com/ElectricR/Encapsul8'
config-add-plugin kakoune-shellcheck  'https://gitlab.com/Screwtapello/kakoune-shellcheck'
config-add-plugin highlighters        'https://github.com/thacuber2a03/highlighters.kak'
config-add-plugin secure-local-kakrc  'https://codeberg.org/ficd/secure-local-kakrc'
config-add-plugin kakoune-repl-buffer 'https://gitlab.com/Screwtapello/kakoune-repl-buffer'
config-add-plugin kak-ansi            'https://github.com/eraserhd/kak-ansi'
config-add-plugin kakoune-filetree    'https://github.com/occivink/kakoune-filetree'

if-not %opt{config_in_termux} %{
	config-add-plugin parinfer-rust 'https://github.com/eraserhd/parinfer-rust'
	config-add-plugin kak-lsp       'https://github.com/kakoune-lsp/kakoune-lsp'
	# config-add-plugin kak-dap       'git clone --revision=355df2c627ceb124f4ff018c95762cf9c19068ae --depth=1 https://codeberg.org/jdugan6240/kak-dap'

	# TODO(thacuber2a03): I need to figure out what the hell is going on with this plugin
	# config-add-plugin kakoune-discord 'https://github.com/thacuber2a03/kakoune-discord'

	config-add-custom-plugin kak-tree-sitter 'https://git.sr.ht/~thacuber2a03/kak-tree-sitter'
} %{
	config-log info "Android detected, disabling certain plugins"
}

config-add-theme ashen 'https://codeberg.org/ficd/kak-ashen'
