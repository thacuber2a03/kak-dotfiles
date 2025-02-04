define-command -docstring "
    source-ex [...]: if no parameters are passed, sources the current buffer.
    otherwise, forwards all of them to source.
" source-ex -params .. %{
    evaluate-commands %sh{
	    if [ "$#" = 0 ]; then
	    	printf %s "source $kak_buffile"; exit
	    fi
	    printf %s "source $@"
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
	reload-selected-commands: re-evaluates the selected commands
" reload-selected-commands %{
  echo -to-shell-script "sed 's/define-command /define-command -override /g' | kak -p %val{session}" -- %val{selections}
}
alias global == reload-selected-commands

#############################################################################################################################################################################

define-command -docstring "
	open-kakrc: open the config kakrc in a new buffer
" open-kakrc %{
	edit! -existing "%val{config}/kakrc"
}

define-command -docstring "
	open-shared-kakrc: open the runtime kakrc in a new buffer
" open-shared-kakrc %{
	edit! -existing -readonly "%val{runtime}/kakrc"
}

#############################################################################################################################################################################

# taken from https://github.com/alexherbo2/dotfiles/blob/master/.local/share/kak/autoload/core/config.kak
# and modified to reflect the style of my config

define-command -docstring "
	open-config <file>: open one of the files in the config dir
" open-config -params 1 %{
	edit! -existing %arg{1}
}

complete-command -menu open-config shell-script-candidates %{
	find -L "$kak_config" -name 'bundle' -prune -o -type f \( -name '*.kak' -o -name 'kakrc' \) -print
	find -L "$kak_config/autoload" "$kak_runtime/autoload" -type f -name '*.kak'
}

alias global config open-config

define-command -docstring "
	grep-config <pattern>: find a grep pattern in all files in the config dir
" grep-config -params 1 %{
	grep %arg{1} "%val{config}" "%val{runtime}/kakrc" "%val{config}/autoload" "%val{runtime}/autoload"
}

complete-command grep-config shell-script-candidates %{
	{
		find -L "$kak_config/kakrc" "$kak_config" -type f -name '*.kak'
		find -L "$kak_config/autoload" "$kak_runtime/autoload" -type f -name '*.kak'
	} |
	xargs grep -o -h -w '[[:alpha:]][[:alnum:]_-]\+' -- |
	sort -u
}
