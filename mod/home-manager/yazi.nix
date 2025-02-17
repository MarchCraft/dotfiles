{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  options.marchcraft.yazi.enable = lib.mkEnableOption "install the yazi config";

  config = lib.mkIf config.marchcraft.yazi.enable {
    programs.yazi = {
      enable = true;
      package = inputs.yazi.packages."${pkgs.stdenv.hostPlatform.system}".default;
      enableFishIntegration = true;
      settings = {
        manager = {
          ratio = [1 1 1];
          sort_by = "alphabetical";
          sort_sensitive = false;
          sort_dir_first = true;
          linemode = "size_and_mtime";
          show_symlink = true;
          scrolloff = 10;
        };
        preview = {
          wrap = "yes";
          tab_size = 4;
        };
        opener = {
          play = [
            {
              run = ''${pkgs.mpv}/bin/mpv "$@"'';
              orphan = true;
              for = "unix";
            }
          ];
          edit = [
            {
              run = ''$EDITOR "$@"'';
              block = true;
              for = "unix";
            }
          ];
          open = [
            {
              run = ''${pkgs.xdg-utils}/bin/xdg-open "$@"'';
              desc = "Open";
            }
          ];
        };
        open = {
          rules = [
            {
              mime = "text/*";
              use = "edit";
            }
            {
              mime = "*.json";
              use = "edit";
            }
            {
              mime = "video/*";
              use = "play";
            }
            {
              mime = "audio/*";
              use = "play";
            }
            {
              mime = "audio/*";
              use = "play";
            }
          ];
        };
        input = {
          origin = "center";
        };
      };
      keymap = {
        manager = {
          prepend_keymap = [
            {
              on = "<C-c>";
              run = "escape --all";
            }
            {
              on = "<C-z>";
              run = "suspend";
            }
            {
              on = "<Backspace>";
              run = "leave";
            }
            {
              on = "-";
              run = "leave";
            }
            {
              on = "<Enter>";
              run = "enter";
            }
            {
              on = "<C-o>";
              run = "back";
            }
            {
              on = "<C-i>";
              run = "forward";
            }
            {
              on = "<C-j>";
              run = "seek 1";
            }
            {
              on = "<C-k>";
              run = "seek -1";
            }
            {
              on = "gd";
              run = "cd --interactive";
            }
            {
              on = "e";
              run = "open";
            }
            {
              on = "d";
              run = "remove --permanently";
            }
            {
              on = "c";
              run = "create";
            }
            {
              on = "R";
              run = "create";
            }
            {
              on = "<C-f>";
              run = "plugin fzf";
            }
            {
              on = "<C-f>";
              run = "plugin fzf";
            }
          ];
        };
      };
    };
    home.file.".config/yazi/init.lua".text = ''
      function Linemode:size_and_mtime()
            local time = math.floor(self._file.cha.mtime or 0)
            if time == 0 then
                    time = ""
            elseif os.date("%Y", time) == os.date("%Y") then
                    time = os.date("%b %d %H:%M", time)
            else
                    time = os.date("%b %d  %Y", time)
            end

            local size = self._file:size()
            return string.format("%s %s", size and ya.readable_size(size) or "-", time)
        end
    '';
  };
}
