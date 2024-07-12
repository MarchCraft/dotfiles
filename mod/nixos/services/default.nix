{ ... }: {
  imports = [
    ./wifi.nix
    ./openssh.nix
    ./yubikey.nix
    ./cups.nix
    ./pika.nix
  ];
}
