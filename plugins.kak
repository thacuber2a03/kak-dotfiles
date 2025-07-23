declare-option str config_plugin_config_directory "plugins"

evaluate-commands %sh{
    bundledir="$kak_config/bundle"

    mkdir -p "$bundledir" || {
        echo "config-fail 'couldn't create bundle directory; stopping'"
        exit 1
    }

    if [ ! -d "$bundledir/kak-bundle" ]; then
        if ! git clone "https://codeberg.org/jdugan6240/kak-bundle" "$bundledir/kak-bundle"; then
            echo "config-fail 'couldn't install bundle; stopping'"
            exit 1
        fi
    fi

    if [ -f "$bundledir/kak-bundle/rc/kak-bundle.kak" ]; then
        echo "
            source '$bundledir/kak-bundle/rc/kak-bundle.kak'
            bundle-noload kak-bundle 'https://codeberg.org/jdugan6240/kak-bundle'
        "
    else
        echo "config-fail 'kak-bundle.kak not found; stopping'"
        exit 1
    fi
}

define-command -hidden -params .. config-add-theme %{
	config-log "adding colorscheme '%arg{1}'"
	bundle-theme %arg{1} %arg{2}
	config-try-source "%opt{config_plugin_config_directory}/%arg{1}.kak"
}

declare-option -hidden str config_plugin_name

define-command -hidden -params .. config-add %{
	config-log "registering plugin '%arg{1}'"
	set-option global config_plugin_name %arg{1}
	bundle %arg{1} %arg{2} %{
		config-try-source "%opt{config_plugin_config_directory}/%opt{config_plugin_name}.kak"
	}
}

define-command -hidden -params .. config-add-custom %{
	config-log "registering plugin '%arg{1}' (custom load)"
	set-option global config_plugin_name %arg{1}
	bundle-customload %arg{1} %arg{2} %{
		config-try-source "%opt{config_plugin_config_directory}/%opt{config_plugin_name}.kak"
	}
}

config-add ui                  'https://github.com/kkga/ui.kak'
config-add Encapsul8           'https://github.com/ElectricR/Encapsul8'
config-add kakoune-shellcheck  'https://gitlab.com/Screwtapello/kakoune-shellcheck'
config-add highlighters.kak    'https://github.com/thacuber2a03/highlighters.kak'
config-add local-kakrc         'https://github.com/thacuber2a03/local-kakrc'
config-add kakoune-repl-buffer 'https://gitlab.com/Screwtapello/kakoune-repl-buffer'
config-add kak-ansi            'https://github.com/eraserhd/kak-ansi'
config-add kakoune-filetree    'https://github.com/occivink/kakoune-filetree'

config-add-theme dracula                    'https://github.com/dracula/kakoune'

try %{
	# these plugins are disabled when using kak in Termux.
	evaluate-commands %sh{ [ "$kak_opt_config_os" = Android ] && printf %s fail }
	config-add        kak-lsp         'https://github.com/kakoune-lsp/kakoune-lsp'
	config-add        kakoune-discord 'https://github.com/ABuffSeagull/kakoune-discord'
	config-add-custom kak-tree-sitter 'https://git.sr.ht/~hadronized/kak-tree-sitter'

	config-add-theme kalolo                     'https://github.com/nojhan/kalolo'
	config-add-theme kakoune-tree-sitter-themes 'https://git.sr.ht/~hadronized/kakoune-tree-sitter-themes'
} catch %{
	config-log "Android detected, disabling Rust based plugins"
}
