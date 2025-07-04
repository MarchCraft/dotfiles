pkgs: {
  # pkg = pkgs.callPackage ./pkg.nix {};
  tidal = pkgs.callPackage ./tidal.nix { };
  pixdecor = pkgs.callPackage ./pixdecor.nix { };
  hyprland-cursor-intersects = pkgs.callPackage ./hyprland-cursor-intersects.nix { };
  hyprland-dpms-toggle = pkgs.callPackage ./hyprland-dpms-toggle.nix { };
  hyprland-mirror = pkgs.callPackage ./hyprland-mirror.nix { };
  nix-trim-generations = pkgs.callPackage ./nix-trim-generations.nix { };
  run-wob = pkgs.callPackage ./run-wob.nix { };
  wob-brightness = pkgs.callPackage ./wob-brightness.nix { };
  wob-volume = pkgs.callPackage ./wob-volume.nix { };
  wp-switch-output = pkgs.callPackage ./wp-switch-output.nix { };
  widevine-firefox = pkgs.callPackage ./firefox-widevine.nix { };
}
