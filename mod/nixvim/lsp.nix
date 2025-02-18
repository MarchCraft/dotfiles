{ ... }:
{

  plugins.lsp = {
    enable = true;
  };
  plugins.lsp.servers.nixd.enable = true;
  plugins.rustaceanvim = {
    enable = true;
  };

  plugins.cmp-nvim-lsp = {
    enable = true;
  };

  plugins.fidget.enable = true;
}
