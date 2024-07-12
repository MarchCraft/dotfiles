{ config
, lib
, ...
}: {
  options.marchcraft.impermanence_home.enable = lib.mkEnableOption "install the git config";

  config = lib.mkIf config.marchcraft.impermanence_home.enable {
    home.persistence."/persist/home" = {
      directories = [
        "Documents"
        ".config/ArmCord"
        ".config/pika-backup"
        ".ssh"
        {
          directory = ".local/share/nvim";
          method = "symlink";
        }
        {
          directory = ".local/state/nvim";
          method = "symlink";
        }
        ".local/state/wireplumber"
        ".gnupg"
        ".config/ZapZap"
        ".cache/ZapZap"
        ".local/share/ZapZap"
        ".rustup"
        ".dotfiles"
        ".mozilla"
      ];
      allowOther = true;
    };

  };
}
