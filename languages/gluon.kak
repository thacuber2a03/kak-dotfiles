# their ls is a bit broken

# config-enable-lsp-support gluon %{
# 	[gluon_language-server]
# 	root_globs = ["main.glu", ".git"]
# }

# so is their formatter...?
# config-set-formatter gluon "gluon fmt"

hook global WinSetOption filetype=gluon %{
	set-option buffer indentwidth 2
}
