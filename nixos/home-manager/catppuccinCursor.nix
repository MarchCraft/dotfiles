{ pkgs }:

pkgs.stdenv.mkDerivation {
    name = "catppuccin-cursor";

    src = pkgs.fetchurl {
        url = "https://github.com/catppuccin/cursors/releases/download/v0.2.0/Catppuccin-Mocha-Mauve-Cursors.zip";
        sha256 = "0k79g7gv3bzi6jzv1wjvck016in7alrj83h44rfmzc9wdqcfzmby";
    };

    dontUnpack = true;

    installPhase = ''
        mkdir -p $out
        ${pkgs.unzip}/bin/unzip $src -d $out/
    '';
}
