map global user d '|xsel --input --clipboard<ret>'                      -docstring "delete to system clipboard"
map global user y '<a-|>xsel --input --clipboard<ret>'                  -docstring "yank to system clipboard"
map global user P '!xsel --output --clipboard<ret>Zs\r<ret>dz<esc>'     -docstring "insert from system clipboard"
map global user p '<a-!>xsel --output --clipboard<ret>Zs\r<ret>dz<esc>' -docstring "append from system clipboard"
map global user R '|xsel --output --clipboard<ret>Zs\r<ret>dz<esc>'     -docstring "replace with system clipboard"

map global user / '/\Q\E<left><left>' -docstring "search literally"
