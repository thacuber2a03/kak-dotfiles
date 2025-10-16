declare-option str config_plugin_config_directory "plugins"

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

# hook global User bundle-after-install %{ quit! }

define-command -hidden -params .. config-add-theme %{
	config-log "adding colorscheme '%arg{1}'"
	bundle-theme %arg{1} %arg{2}
	config-try-source "%opt{config_plugin_config_directory}/%arg{1}.kak"
}

declare-option -hidden str-list config_plugins # loaded plugins

declare-option -hidden str config_current_plugin_name

define-command -hidden -params .. config-add-plugin %{
	config-log "registering plugin '%arg{1}'"
	set-option -add global config_plugins %arg{1}
	set-option local config_current_plugin_name %arg{1}
	bundle %arg{1} %arg{2} %{
		config-try-source "%opt{config_plugin_config_directory}/%opt{config_current_plugin_name}.kak"
	}
}

define-command -hidden -params .. config-add-custom %{
	config-log "registering plugin '%arg{1}' (custom load)"
	set-option -add global config_plugins %arg{1}
	set-option local config_current_plugin_name %arg{1}
	bundle-customload %arg{1} %arg{2} %{
		config-try-source "%opt{config_plugin_config_directory}/%opt{config_current_plugin_name}.kak"
	}
}

define-command -docstring "
	config-show-plugins: opens a new buffer showing all installed plugins
" -params 0 config-show-plugins %{
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
	}
}

config-add-plugin ui                  'https://github.com/kkga/ui.kak'
config-add-plugin Encapsul8           'https://github.com/ElectricR/Encapsul8'
config-add-plugin kakoune-shellcheck  'https://gitlab.com/Screwtapello/kakoune-shellcheck'
config-add-plugin highlighters.kak    'https://github.com/thacuber2a03/highlighters.kak'
config-add-plugin local-kakrc         'https://github.com/thacuber2a03/local-kakrc'
config-add-plugin kakoune-repl-buffer 'https://gitlab.com/Screwtapello/kakoune-repl-buffer'
config-add-plugin kak-ansi            'https://github.com/eraserhd/kak-ansi'
config-add-plugin kakoune-filetree    'https://github.com/occivink/kakoune-filetree'
config-add-plugin kakoune-palette     'https://github.com/Delapouite/kakoune-palette'

config-add-theme kalolo         'https://github.com/nojhan/kalolo'
config-add-theme dracula        'https://github.com/thacuber2a03/dracula-kakoune'
config-add-theme everforest     'https://codeberg.org/jdugan6240/everforest.kak'
config-add-theme ashen          'https://codeberg.org/ficd/kak-ashen'
config-add-theme kakoune-themes 'https://codeberg.org/anhsirk0/kakoune-themes'

try %{
	# these plugins are disabled when using kak in Termux.
	evaluate-commands %sh{ [ "$kak_opt_config_os" = Android ] && printf %s fail }

	config-add-plugin parinfer-rust   'https://github.com/eraserhd/parinfer-rust'
	config-add-plugin kak-lsp         'https://github.com/kakoune-lsp/kakoune-lsp'
	config-add-plugin kakoune-discord 'https://github.com/thacuber2a03/kakoune-discord'
	config-add-plugin kak-niri        'https://codeberg.org/ficd/kak-niri'

	config-add-custom kak-tree-sitter 'https://git.sr.ht/~hadronized/kak-tree-sitter'

	config-add-theme kakoune-tree-sitter-themes 'https://git.sr.ht/~hadronized/kakoune-tree-sitter-themes'
} catch %{
	config-log "Android detected, disabling certain plugins"
}
