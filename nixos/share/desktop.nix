{ config, lib, pkgs, ... }:

{
    sound.enable = true;

    imports =[
        ./virtualmachines.nix
        ./hyprland.nix
        ./wifi.nix
    ];

    sops.age.sshKeyPaths = [ "/persist/system/etc/ssh/ssh_host_ed25519_key" ];

    sops.secrets.felix_pwd = {
        format = "binary";
        sopsFile = ../../secrets_age/felix_pwd;
        neededForUsers = true;
    };

    users.users.felix = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager"  "libvirtd"];
        hashedPasswordFile = config.sops.secrets.felix_pwd.path;
        shell = pkgs.fish;
    };
    
    users.users.test = {
       isNormalUser = true;
       extraGroups = [ "wheel" ];
       password = "test";
    };

    users.defaultUserShell = pkgs.fish;

    programs.neovim.enable = true;
    programs.neovim.defaultEditor = true;
    programs.neovim.withPython3 = true;
    programs.neovim.viAlias = true;

    programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 4d --keep 10";
        flake = "/home/felix/dotfiles";
    };

    programs.fish.enable = true;

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
            run-shell ${pkgs.tmuxPlugins.yank}/share/tmux-plugins/yank/yank.tmux
            run-shell ${pkgs.tmuxPlugins.sensible}/share/tmux-plugins/sensible/sensible.tmux
            run-shell ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux
            '';
        plugins = with pkgs.tmuxPlugins; [
            catppuccin
        ];

    };
    environment.systemPackages = with pkgs; [
        vim
        gcc
        cryptsetup
        wget
        fastfetch
        starship
        zoxide
        fd
        fzf
        nodejs
        (python312.withPackages (python-pkgs: [
            python-pkgs.requests
        ]))
        cmake
        wl-clipboard
        polkit_gnome
        greetd.regreet
        dracula-theme
        unzip
        xdg-utils
        libsForQt5.networkmanager-qt
        thunderbird
        killall
        btop
        postman
        jetbrains.datagrip
        pamixer
        lazygit
        nix-search-cli
        pinentry-qt
        eza
        prismlauncher
        rustup
        rust-analyzer
        pkg-config
        openssl
        ripgrep
        hugo
        go
        wayland-pipewire-idle-inhibit
        beautysh
        hadolint
        statix
        alejandra
        ruff
        black
        taplo
        prettierd
        nodePackages.bash-language-server
        nodePackages.typescript-language-server
        clojure-lsp
        texlab
        lua-language-server
        marksman
        pyright
        zls
        vscode-langservers-extracted
        jdt-language-server
        vscode-extensions.vscjava.vscode-java-debug
        vscode-extensions.vscjava.vscode-java-test
        bat
      
        jq
        libreoffice-qt
        hunspell
        hunspellDicts.en_US
        hunspellDicts.de_DE
        pass
        passff-host
        evince
        texlab
        nix-index
        zathura
        discord-screenaudio
        element-desktop
        nchat
    ];

    services.pcscd.enable = true;

    programs.thunar.enable = true;
    programs.xfconf.enable = true;

    programs.thunar.plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
    ];

    services.gvfs.enable = true; # Mount, trash, and other functionalities
    services.tumbler.enable = true; # Thumbnail support for images
    environment.variables = {
        EDITOR = "vi";
        DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";
        XCURSOR_SIZE = "32";
        GTK_THEME = "Dracula";
        PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig";
        FLAKE = "/home/felix/dotfiles";
    };

    programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
        pinentryPackage = pkgs.pinentry-qt;
    };

    networking.firewall = {
        enable = true;
        allowedTCPPorts = [80 8080 22];
    };

    services.openssh = {
        enable = true;
        settings.PasswordAuthentication = false;
    };

    users.users.felix.openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDVGapwmgI9ZL7tf6YrcZP2T+rnmrnCgelOybl7yk60QvVhfc1ikOjagkXpXj28wX0JXMKS+1qiIJEz5SkSbhMl67wz2DXzxGx5Xe1WOZltsY7RAg4gbDh71cUxaeYB0J9geXr1HITDbcvb8r5VO910pB5bUtYGUzcWG2wY+brU4pq6rGc9IGjNuQ7kl3q4Rk4ZjUjI5VarBQrLlXWbn5COlhasvdnAd05zVN2J+868Jkxzy9DKjy6svPQqnzL40nP1oZYKQNmTxtsl+V+ScBXnZFjjxA7eoTbQ8M3kZS8FKu3V+Cn6of7BCV+kE4lMsXyhZLDKlyqwYjAkBsXYvAqGeovOH9bI2FX/iQBDOBQUlnBFxGXEZOpSs9/6EDF0V6mEw9mwkGrrXE5HnBjghuZtaWSmHRZZ/wL5gyKSmDOk0+vrUTWeldQ1Wj+l4qVPpRB5vBA6Riga7pEcqE8h7IgtqMiQXA+pSy2pVA1cRaRmJ57FMMuaLfLKDhgPLoRougVZF12aPdN13tuwy8H8Py0ARKPFY1P2GfmPzB0t1fEScfT1dgenSDCb0XJU//zvbOmf/AF0ZSAD2Y7LHcaXTDtOTblYPsm5FNmPvt4XW9mh8pweqIKh6xrkZa84yN8Jj7pIueXUMaXQjN/DzAm7M6uTTCzkRZmC7L3lSyN23oIjnw=="
    ];
}

