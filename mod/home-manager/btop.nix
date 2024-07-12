{ config
, lib
, ...
}: {
  options.marchcraft.btop.enable = lib.mkEnableOption "install the btop config";

  config = lib.mkIf config.marchcraft.btop.enable {
    programs.btop = {
      enable = true;
      settings = {
        vim_keys = true;
        proc_sorting = "cpu lazy";
        proc_per_core = true;
      };
    };
  };
}
