{ lib
, config
, pkgs
, ...
}: {
  options.marchcraft.services.yubikey.enable = lib.mkEnableOption "enable yubikey";
  config = lib.mkIf config.marchcraft.services.openssh.enable {
    environment.systemPackages = with pkgs; [
      yubikey-personalization
      gnupg
      pinentry-qt
    ];
    services.udev.packages = with pkgs; [
      yubikey-personalization
    ];

    programs.gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-qt;
      enableSSHSupport = true;
    };

    # Use GPG Agent instead of SSH Agent
    programs.ssh.startAgent = lib.mkIf config.services.openssh.enable false;
    environment.shellInit = lib.mkIf config.services.openssh.enable ''
      gpg-connect-agent /bye
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      echo UPDATESTARTUPTTY | gpg-connect-agent
    '';
  };
}
