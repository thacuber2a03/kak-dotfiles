require-module niri

declare-option -docstring 'interactive shell to use with new niri terminal windows' str niri_shell 'fish'
define-command terminal-consume %{
    niri-terminal-consume %opt{niri_shell}
}
define-command terminal-consume-right %{
    niri-terminal-consume-right %opt{niri_shell}
}
define-command terminal-window %{
    niri-terminal-window %opt{niri_shell}
}
alias global t terminal-window
alias global tc terminal-consume
alias global tcr terminal-consume-right
alias global n niri-new-window
alias global nc niri-new-consume
alias global ncr niri-new-consume-right
