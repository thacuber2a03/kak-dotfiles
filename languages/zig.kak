config-enable-lsp-and-ts zig %{
    [zls]
    root_globs = ["build.zig"]
    settings_section = "zls"

    [zls.settings.zls]
    inlay_hints_hide_redundant_param_names = true
}

