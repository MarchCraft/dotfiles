{ pkgs, lib, ... }:
{
  extraPackages = [
    pkgs.nixfmt-rfc-style
    pkgs.gcc
  ];

  plugins.rustaceanvim = {
    enable = true;
  };

  plugins.conform-nvim = {
    enable = true;
    autoInstall.enable = true;
    settings = {
      formatters_by_ft = {
        bash = [
          "shellcheck"
          "shellharden"
          "shfmt"
        ];
        cpp = [ "clang_format" ];
        javascript = {
          __unkeyed-1 = "prettierd";
          __unkeyed-2 = "prettier";
          timeout_ms = 2000;
          stop_after_first = true;
        };
        html = [
          "prettier"
        ];
        "_" = [
          "squeeze_blanks"
          "trim_whitespace"
          "trim_newlines"
        ];
      };
      format_on_save = # Lua
        ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end

            return { timeout_ms = 200, lsp_fallback = true }, on_format
           end
        '';
      format_after_save = # Lua
        ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end

            return { lsp_fallback = true }
          end
        '';
      log_level = "warn";
      notify_on_error = false;
      notify_no_formatters = false;
      formatters = {
        shellcheck = {
          command = lib.getExe pkgs.shellcheck;
        };
        shfmt = {
          command = lib.getExe pkgs.shfmt;
        };
        shellharden = {
          command = lib.getExe pkgs.shellharden;
        };
        squeeze_blanks = {
          command = lib.getExe' pkgs.coreutils "cat";
        };
        prettier = {
          command = lib.getExe pkgs.prettier;
        };
      };
    };
  };

  plugins.flutter-tools = {
    enable = true;
  };

  plugins.cmp-nvim-lsp = {
    enable = true;
  };

  plugins.fidget.enable = true;
  plugins.vimtex = {
    enable = true;
    settings.view_method = "zathura";
  };

  plugins.lsp = {
    enable = true;
    servers =
      let
        start-jdt-server = lib.getExe (pkgs.writeShellScriptBin "start-jdt-server" "jdtls");
      in
      {
        nixd.enable = true;
        nixd.settings.formatting.command = [ "nixfmt" ];
        java_language_server = {
          enable = true;
          cmd = [ "${start-jdt-server}" ];
          package = pkgs.jdt-language-server;
        };
        zls.enable = true;
      };
  };

  plugins.jdtls = {
    enable = true;
    settings.java.gradle.enabled = true;
    settings.root_dir = lib.nixvim.mkRaw "require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'})";
  };

  # DAP

  plugins.cmp-dap.enable = true;
  plugins.dap = {
    enable = true;
    signs = {
      dapBreakpoint = {
        text = "●";
        texthl = "DapBreakpoint";
      };
      dapBreakpointCondition = {
        text = "●";
        texthl = "DapBreakpointCondition";
      };
      dapLogPoint = {
        text = "◆";
        texthl = "DapLogPoint";
      };
    };

    adapters.servers.java = {
      host = "127.0.0.1";
      port = 5006;
      id = "2";
      executable = {
        command = "java";
        args = [
          "-jar"
          "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server/com.microsoft.java.debug.plugin-0.53.1.jar"
        ];
      };
    };

    configurations.java = [
      {
        type = "java";
        request = "attach";
        name = "Debug (Attach) - Remote";
        hostName = "127.0.0.1";
        port = 5005;
      }
    ];
  };
  plugins.dap-ui.enable = true;
}
