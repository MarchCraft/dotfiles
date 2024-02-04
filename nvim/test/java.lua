local config = {
    cmd = {vim.fn.expand("/opt/homebrew/bin/jdtls")},

    root_dir = vim.fs.dirname(vim.fs.find({ "grandlew", ".git", "mvnw"}, {upward =true})[1]),  
    init_options = {
        bundles = {
            vim.fn.glob('/Users/felixnilles/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-0.50.0.jar',1),
        },
    },
  
}
config['on_attach'] = function(client, bufnr)
  -- With `hotcodereplace = 'auto' the debug adapter will try to apply code changes
  -- you make during a debug session immediately.
  -- Remove the option if you do not want that.
  require('jdtls').setup_dap({ hotcodereplace = 'auto' })
end
print(config)
--require('jdtls').start_or_attach(config)


