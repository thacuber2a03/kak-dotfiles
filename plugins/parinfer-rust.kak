bundle-install-hook parinfer-rust %{ cargo install --force --path . }
bundle-cleaner      parinfer-rust %{ cargo uninstall parinfer-rust }

declare-option str-list parinfer_extra_flags

# define-command -docstring "
# 	parinfer: reformat buffer with parinfer-rust
# " parinfer -params 0 %{
# 	evaluate-commands -save-regs '/"|^@sa' -no-hooks %{
# 		set-register s %val{selections_desc}
# 		evaluate-commands -draft %{
# 			execute-keys '%'
# 			set-register a %sh{
# 				result=$(printf '%s' "$kak_reg_dot" | parinfer-rust -m smart "$kak_opt_parinfer_extra_flags")
# 				[ $? -eq 0 ] && printf '%s' "$result"
# 			}
# 			execute-keys -draft %sh{ [ -n "$kak_reg_a" ] && printf '"aR' }
# 		}
# 		select %reg{s}
# 	}
# }
