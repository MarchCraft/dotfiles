vim.opt.guicursor = "i:ver20"

vim.loader.enable()

vim.g.netrw_banner = 0
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 8
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.opt.cmdheight = 0

local file_event = vim.api.nvim_create_augroup("UserFileEvents", {});

local function runcmd(cmd, show_error)
    if type(cmd) == "string" then cmd = { cmd } end
    if vim.fn.has "win32" == 1 then cmd = vim.list_extend({ "cmd.exe", "/C" }, cmd) end
    local result = vim.fn.system(cmd)
    local success = vim.api.nvim_get_vvar "shell_error" == 0
    if not success and (show_error == nil or show_error) then
        vim.api.nvim_err_writeln(("Error running command %s\nError message:\n%s"):format(table.concat(cmd, " "), result))
    end
    return success and result:gsub("[\27\155][][()#;?%d]*[A-PRZcf-ntqry=><~]", "") or nil
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePost" }, {
    group = file_event,
    callback = function(args)
        if not (vim.fn.expand "%" == "" or vim.api.nvim_get_option_value("buftype", { buf = args.buf }) == "nofile") then
            vim.api.nvim_exec_autocmds("User", {
                pattern = "File",
                modeline = false,
            })
            if
                runcmd({ "git", "-C", vim.fn.expand "%:p:h", "rev-parse" }, false)
            then
                vim.api.nvim_exec_autocmds("User", {
                    pattern = "GitFile",
                    modeline = false,
                })
                vim.api.nvim_del_augroup_by_name("UserFileEvents")
            end
        end
    end,
})
    
