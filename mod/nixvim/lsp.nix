{ pkgs, lib, ... }:
{
  extraPackages = [
    pkgs.nixfmt-rfc-style
    pkgs.gcc
  ];

  plugins.rustaceanvim = {
    enable = true;
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
