{ pkgs, ... }:
{
  plugins.lsp = {
    enable = true;
  };

  plugins.lsp.servers.nixd.enable = true;
  plugins.lsp.servers.nixd.settings.formatting.command = [ "nixfmt" ];
  extraPackages = [
    pkgs.nixfmt-rfc-style
  ];

  plugins.rustaceanvim = {
    enable = true;
  };

  plugins.flutter-tools = {
    enable = true;
  };

  plugins.cmp-nvim-lsp = {
    enable = true;
  };

  plugins.fidget.enable = true;
  plugins.vimtex = {
    enable = true;
    settings.view_method = "zathura";
  };
}
