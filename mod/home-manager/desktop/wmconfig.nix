{ lib, ... }:

{
  options.marchcraft.desktop.wmconfig = {
    keyboardLayout = lib.mkOption {
      type = lib.types.str;
      default = "de";
      description = "Keyboard layout to use in river.";
    };

    outputs = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Name of the output (e.g. eDP-1, HDMI-A-1, etc.).";
            };
            scale = lib.mkOption {
              type = lib.types.nullOr lib.types.number;
              default = null;
              description = "Scale factor for the output (e.g. 1, 1.5, 2, etc.).";
            };
            primary = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether this output should be the primary output.";
            };
            position = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Position of the output (e.g. 0x0, 1920x0, etc.).";
            };
          };
        }
      );
      default = [
        {
          name = "eDP-1";
          scale = 1;
          position = null;
          primary = true;
        }
      ];
      description = "List of output configurations for wlr-randr.";
    };

    superKey = lib.mkOption {
      type = lib.types.str;
      default = "Super";
      description = "Modifier key to use as the 'super' key in river.";
    };
  };
}
