bundle-install-hook parinfer-rust %{ cargo install --force --path . }
bundle-cleaner parinfer-rust %{ cargo uninstall parinfer-rust }

hook global WinSetOption filetype=(fe(nnel)?|yuck|scheme) %{
	remove-hooks global auto-indent
	parinfer-enable-window -smart
	hook window WinSetOption filetype=.* %{ config-define-auto-insert-hooks }
}

