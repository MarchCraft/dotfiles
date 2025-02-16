{ config
, pkgs
, lib
, ...
}: {
  options.marchcraft.shell.direnv.enable = lib.mkEnableOption "configure magic direnv";

  config = lib.mkIf config.marchcraft.shell.direnv.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config = {
        hide_env_diff = true;
        strict_env = true;
        warn_timeout = "20s";
      };
      stdlib = ''
        : "''${XDG_CACHE_HOME:="''${HOME}/.cache"}"
        declare -A direnv_layout_dirs
        direnv_layout_dir() {
            local hash path
            echo "''${direnv_layout_dirs[$PWD]:=$(
                hash="$(sha1sum - <<< "$PWD" | head -c40)"
                path="''${PWD//[^a-zA-Z0-9]/-}"
                echo "''${XDG_CACHE_HOME}/direnv/layouts/''${hash}''${path}"
            )}"
        }
      '';
    };
  };
}
