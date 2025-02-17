{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.marchcraft.shell.tmux.enable = lib.mkEnableOption "install 0x5a4s starship config";

  config = lib.mkIf config.marchcraft.shell.tmux.enable {
    programs.tmux =
      let
        pane_title = pkgs.writeScriptBin "pane_title.sh" ''
          #!/usr/bin/env bash

          cd $1
          current_path="$(git rev-parse --show-toplevel 2> /dev/null || pwd)"
          trim_home="$(echo $current_path | sed "s?/home/$(whoami)\+?~?")"
          echo $trim_home | rev | cut -d/ -f1-2 | rev
        '';
      in
      {
        enable = true;
        newSession = true;
        keyMode = "vi";
        historyLimit = 5000;
        clock24 = true;
        terminal = "screen-256color";
        plugins = with pkgs.tmuxPlugins; [
          {
            plugin = resurrect;
          }
          {
            plugin = continuum;
            extraConfig = ''
              set -g @continuum-restore 'on'
            '';
          }
        ];
        extraConfig = ''
          set-option -g status-interval 2
          set-option -g automatic-rename on
          set-option -g automatic-rename-format '#(${pane_title} #{pane_current_path}):#{pane_current_command}'

          unbind %
          unbind '"'

          bind b split-window -c "#{pane_current_path}"
          bind v split-window -h -c "#{pane_current_path}"

          bind g copy-mode
          set -g base-index 1
          setw -g pane-base-index 1
          set-window-option -g pane-base-index 1
          bind x kill-pane

          set -g @catppuccin_flavour 'mocha'
          set -g @catppuccin_date_time "%d.%m.%Y %H:%M"
          set -g @catppuccin_powerline_icons_theme_enabled on
          set -g @catppuccin_l_left_separator ""
          set -g @catppuccin_l_right_separator ""
          set -g @catppuccin_r_left_separator ""
          set -g @catppuccin_r_right_separator ""
          set -g @continuum-save-interval '1'
          set -g status-right 'Continuum status: #{continuum_status}'
          set -g mouse on
          run-shell ${pkgs.tmuxPlugins.yank}/share/tmux-plugins/yank/yank.tmux
          run-shell ${pkgs.tmuxPlugins.sensible}/share/tmux-plugins/sensible/sensible.tmux
          run-shell ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux
          is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
              | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
          bind-key -n 'M-h' if-shell "$is_vim" 'send-keys M-h'  'select-pane -L'
          bind-key -n 'M-j' if-shell "$is_vim" 'send-keys M-j'  'select-pane -D'
          bind-key -n 'M-k' if-shell "$is_vim" 'send-keys M-k'  'select-pane -U'
          bind-key -n 'M-l' if-shell "$is_vim" 'send-keys M-l'  'select-pane -R'

          bind-key -T copy-mode-vi 'M-h' select-pane -L
          bind-key -T copy-mode-vi 'M-j' select-pane -D
          bind-key -T copy-mode-vi 'M-k' select-pane -U
          bind-key -T copy-mode-vi 'M-l' select-pane -R

        '';
      };
  };
}
