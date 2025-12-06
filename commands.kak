define-command -docstring "
	source-ex [...]: if no parameters are passed, sources the current buffer.
	otherwise, forwards all of them to source
" source-ex -params .. %{
	evaluate-commands %sh{
		if [ "$#" = 0 ]; then
			printf %s "source $kak_buffile"
		else
			printf %s "source $*"
		fi
	}
}
complete-command source-ex file
alias global . source-ex

#############################################################################################################################################################################

define-command -docstring "
	evaluate-selection: evaluates the selection as if entered by user
" evaluate-selection %{
	# TODO: check if evaluating all selections would be undesirable
	execute-keys -with-hooks ':<c-r><a-.><ret>'
}
alias global = evaluate-selection

#############################################################################################################################################################################

define-command -docstring "
	reload-selected-commands: reloads the selected commands (can also evaluate the main selection)
" reload-selected-commands %{
	echo -to-shell-script "sed 's/define-command /define-command -override /g' | kak -p %val{session}" -- %val{selections}
}
alias global == reload-selected-commands

#############################################################################################################################################################################

# taken from https://github.com/alexherbo2/dotfiles/blob/master/.local/share/kak/autoload/core/config.kak
# and modified to reflect the style of my config

define-command -docstring "
	open-config <file>: open one of the files in the config dir
" open-config -params 1 %{
	edit! -existing %arg{1}
}

complete-command -menu open-config shell-script-candidates %{
	echo "$kak_config/kakrc"
	find -L "$kak_config" -name 'bundle' -prune -o -type f -name '*.kak' -print
}

alias global config open-config

define-command -docstring "
	open-shared-config <file>: open one of the files in the runtime dir (in readonly mode)
" open-shared-config -params 1 %{
	edit! -existing -readonly %arg{1}
}

complete-command -menu open-shared-config shell-script-candidates %{
	echo "$kak_runtime/kakrc"
	find -L "$kak_runtime" -type f -name '*.kak'
}

alias global shared-config open-shared-config

define-command -docstring "
	grep-config <pattern>: find a grep pattern in all files in the config dir
" grep-config -params 1 %{
	grep --exclude-dir=bundle -- %arg{1} "%val{config}" "%val{config}/kakrc"
}

complete-command grep-config shell-script-candidates %{
	{
		echo "$kak_config/kakrc"
		find -L "$kak_config" -name 'bundle' -prune -o -type f -name '*.kak' -print
	} \
	| xargs grep -o -h -w '[[:alpha:]][[:alnum:]_-]\+' -- \
	| sort -u
}

#############################################################################################################################################################################

define-command -docstring "open-kakrc: open the config kakrc in a new buffer"                            open-kakrc        'open-config kakrc'
define-command -docstring "open-shared-kakrc: open the runtime kakrc in a new buffer (in readonly mode)" open-shared-kakrc 'open-shared-config kakrc'

#############################################################################################################################################################################

define-command -docstring "
	afk: show an 'AFK' modal text that disappears as soon as a key is pressed
" afk %{
	info -style modal -title afk "not here, brb"
	on-key %{
		info -style modal
		echo "I'm back :D"
	}
}

define-command -docstring "
	enable-reading-mode: disables line numbers, whitespace highlighting
	and the git diff gutter, and enables soft-wrapping
" enable-reading-mode %{
	try %{ ui-git-diff-disable     }
	try %{ ui-line-numbers-disable }
	try %{ ui-whitespaces-disable  }
	try %{ ui-wrap-enable          }
}
