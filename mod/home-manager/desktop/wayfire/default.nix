{ config
, lib
, pkgs
, inputs
, ...
}: {
  options.marchcraft.desktop.wayfire = {
    enable = lib.mkEnableOption "install the wayfire config";
  };

  config = lib.mkIf config.marchcraft.desktop.wayfire.enable {
    home.packages = with pkgs; [
      grim
      slurp
      pamixer
      brightnessctl
      wlinhibit
      xdg-desktop-portal-gtk
      xdg-desktop-portal-xapp
      xdg-desktop-portal-gnome
      xdg-desktop-portal-wlr
      wl-clipboard
      autotiling-rs
      grim
      slurp
      wlogout
    ];

    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.catppuccin-cursors.mochaMauve;
      name = "catppuccin-mocha-mauve-cursors";
      size = 40;
      x11 = {
        enable = true;
        defaultCursor = config.home.pointerCursor.name;
      };
    };
  };
}
