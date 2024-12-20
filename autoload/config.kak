# borrowed and slightly modified from 
# https://github.com/alexherbo2/dotfiles/blob/master/.local/share/kak/autoload/core/config.kak

define-command open_kakrc %{ edit "%val{config}/kakrc" }

define-command open_config -params 1 -docstring 'open config' %{ edit -existing -readonly %arg{1} }

complete-command -menu open_config shell-script-candidates %{
  find -L "$kak_config/kakrc" "$kak_runtime/kakrc" -type f -name 'kakrc'
  find -L "$kak_config/autoload" "$kak_config/colors" "$kak_runtime/autoload" "$kak_runtime/colors" -type f -name '*.kak'
}

alias global config open_config

define-command grep_config -params 1 -docstring 'grep config' %{
  grep %arg{1} "%val{config}/kakrc" "%val{runtime}/kakrc" "%val{config}/autoload" "%val{config}/colors" "%val{runtime}/autoload" "%val{runtime}/colors"
}

complete-command grep_config shell-script-candidates %{
  {
    find -L "$kak_config/kakrc" "$kak_runtime/kakrc" -type f -name 'kakrc'
    find -L "$kak_config/autoload" "$kak_config/colors" "$kak_runtime/autoload" "$kak_runtime/colors" -type f -name '*.kak'
  } |
  xargs grep -o -h -w '[[:alpha:]][[:alnum:]_-]\+' -- |
  sort -u
}
