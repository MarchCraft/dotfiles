{
  inputs,
  config,
  ...
}: {
  imports = [
    ../../mod/home-manager # if accessed via output, infinite recursion occurs
    inputs.nur.modules.homeManager.default
  ];

  marchcraft.shell = {
    enableAliases = true;
    installTools = true;
    fish.enable = true;
    starship.enable = true;
    tmux.enable = true;
  };

  marchcraft.git.enable = true;
  marchcraft.btop.enable = true;
  marchcraft.neovim.enable = true;

  marchcraft.desktop.apps.firefox.enable = true;

  sops = {
    age.sshKeyPaths = [
      "/persist/home/ssh_host_ed25519_key"
    ];
  };

  marchcraft.rofi = {
    enable = true;
  };
  marchcraft.waybar.enable = true;
  marchcraft.yazi.enable = true;

  marchcraft.misc.enable = true;

  marchcraft.desktop.wayfire.enable = true;
  marchcraft.desktop.wayfire.keyboard_layout = "us";
  marchcraft.desktop.wayfire.super_key = "super";
  marchcraft.desktop.swaync.enable = true;
  marchcraft.desktop.apps.kitty.enable = true;
  marchcraft.desktop.swayidle.enable = true;

  home.stateVersion = "23.11";
}
