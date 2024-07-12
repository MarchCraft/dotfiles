{ config
, pkgs
, lib
, ...
}: {
  options.marchcraft.shell.tmux.enable = lib.mkEnableOption "install 0x5a4s starship config";

  config = lib.mkIf config.marchcraft.shell.tmux.enable {
    programs.tmux = {
      enable = true;
      newSession = true;
      keyMode = "vi";
      historyLimit = 5000;
      clock24 = true;
      terminal = "screen-256color";
      extraConfig = ''
        set -g @catppuccin_flavour 'mocha'
        set -g @catppuccin_date_time "%d.%m.%Y %H:%M"
        set -g @catppuccin_powerline_icons_theme_enabled on
        set -g @catppuccin_l_left_separator ""
        set -g @catppuccin_l_right_separator ""
        set -g @catppuccin_r_left_separator ""
        set -g @catppuccin_r_right_separator ""
        set -g mouse on
        run-shell ${pkgs.tmuxPlugins.yank}/share/tmux-plugins/yank/yank.tmux
        run-shell ${pkgs.tmuxPlugins.sensible}/share/tmux-plugins/sensible/sensible.tmux
        run-shell ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux
      '';
      plugins = with pkgs.tmuxPlugins; [
        catppuccin
      ];

    };
  };
}
