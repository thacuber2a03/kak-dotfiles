hook -group lsp-filetype-zig global BufSetOption filetype=zig %{
    set-option buffer lsp_servers %{
        [zls]
        root_globs = ["build.zig"]
        settings_section = "zls"

        [zls.settings.zls]
        inlay_hints_hide_redundant_param_names = true
    }
}
