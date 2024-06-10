return {
    'mfussenegger/nvim-jdtls',
    ft = 'java',
    dependencies = {
        'VonHeikemen/lsp-zero.nvim'
    },
    config = function()
        local present, jdtls = pcall(require, "jdtls")
        local presents, jdtlsd = pcall(require, "jdtls.dap")

        local path = {}

        path.bundles = {}

        local java_test_path = require('mason-registry')
        .get_package('java-test')
        :get_install_path()

        local java_test_bundle = vim.split(
        vim.fn.glob(java_test_path .. '/extension/server/*.jar'),
        '\n'
        )

        if java_test_bundle[1] ~= '' then
            vim.list_extend(path.bundles, java_test_bundle)
        end

        ---
        -- Include java-debug-adapter bundle if present
        ---
        local java_debug_path = require('mason-registry')
        .get_package('java-debug-adapter')
        :get_install_path()

        local java_debug_bundle = vim.split(
        vim.fn.glob(java_debug_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar'),
        '\n'
        )

        if java_debug_bundle[1] ~= '' then
            vim.list_extend(path.bundles, java_debug_bundle)
        end
        local config = {
            cmd = {"jdtls"}, 
            root_dir = vim.fs.dirname(vim.fs.find({ ".gradlew", ".git", "mvnw" }, { upward = true })[1]),
            init_options = {
                bundles = path.bundles,
            },
            on_attach = jdtls_on_attach,

        }
        jdtls.start_or_attach(config)
        local function jdtls_on_attach(client, bufnr)
            jdtls.setup_dap({hotcodereplace = 'auto'})
            jdtlsd.setup_dap_main_class_configs()

            local opts = {buffer = bufnr}
            vim.keymap.set('n', '<leader>df', "<cmd>lua require('jdtls').test_class()<cr>", opts)
            vim.keymap.set('n', '<leader>dn', "<cmd>lua require('jdtls').test_nearest_method()<cr>", opts)


            require('jdtls.dap').setup_dap_main_class_configs()
        end



    end,
}
