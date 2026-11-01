config-enable-lsp-support java %{
    [jdtls]
    command = "jdtls-wrapper"
    root_globs = ["mvnw", "gradlew", ".git", ".hg"]
    settings_section = "_"
    workspace_did_change_configuration_subsection = "settings"
    [jdtls.settings._.settings]
    # See https://github.com/eclipse-jdtls/eclipse.jdt.ls/blob/main/org.eclipse.jdt.ls.core/src/org/eclipse/jdt/ls/core/internal/preferences/Preferences.java
    # "java.format.enabled" = true
}

hook global WinSetOption filetype=java %{
	set-option buffer indentwidth 4
}
