# currently unused. - tc

# This script enables full background coloring of buffer regions.
# Author: Francois Tonneau

declare-option -hidden str shadow_target

declare-option -hidden str shadow_start
declare-option -hidden str shadow_stop
declare-option -hidden str shadow_face

define-command -docstring 'shadow-enable <filetype> <opening_regex> <closing_regex> <face>' \
-params 4 shadow-enable %{
    set-option global shadow_target %arg(1)
    set-option global shadow_start  %arg(2)
    set-option global shadow_stop   %arg(3)
    set-option global shadow_face   %arg(4)

    hook global WinSetOption "filetype=%opt(shadow_target)" %{
        hook -group shadow window NormalIdle .* %{
            shadow-update-areas %opt(shadow_start) %opt(shadow_stop) %opt(shadow_face)
        }
        hook -group shadow window InsertIdle .* %{
            shadow-update-areas %opt(shadow_start) %opt(shadow_stop) %opt(shadow_face)
        }
        hook -once -always window WinSetOption filetype=.* %{
            shadow-remove
        }
    }
}

define-command -hidden -params 3 shadow-update-areas %{
    set-option window shadow_start %arg(1)
    set-option window shadow_stop  %arg(2)
    set-option window shadow_face  %arg(3)

    add-highlighter -override window/shadow group
    try %{
        evaluate-commands -draft %{
            execute-keys <percent> s "%opt(shadow_start).*?" "%opt(shadow_stop)" <ret> <a-s>
            evaluate-commands -itersel %{
                add-highlighter window/shadow/ line %val(cursor_line) %opt(shadow_face)
            }
        }
    }
}

define-command -docstring 'shadow-remove: remove shadows from current window' \
shadow-remove %{
    try %{
        remove-hooks window shadow
        remove-highlighter window/shadow
    }
}

