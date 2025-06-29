{
  inputs,
  config,
  ...
}:
{
  imports = [
    ../../mod/home-manager # if accessed via output, infinite recursion occurs
    inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.nur.modules.homeManager.default
    inputs.nixcord.homeModules.nixcord
    ./share.nix
  ];

  marchcraft.shell = {
    enableAliases = true;
    installTools = true;
    fish.enable = true;
    starship.enable = true;
    tmux.enable = true;
    direnv.enable = true;
  };

  marchcraft.git.enable = true;
  marchcraft.btop.enable = true;
  marchcraft.neovim.enable = false;

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

  marchcraft.desktop.swaync.enable = true;
  marchcraft.desktop.apps.kitty.enable = true;
  marchcraft.desktop.apps.ghostty.enable = true;
  marchcraft.desktop.swayidle.enable = true;

  home.stateVersion = "23.11";
}
