{
    config,
    pkgs,
    inputs,
    ...
}: {

    home.stateVersion = "18.09";
    home.username = "felix";
    home.homeDirectory = "/home/felix";
    home.persistence."/persist/home" = {
    	directories = [
            "dotfiles"
            ".mozilla"
            "Documents"
            ".config/ArmCord"
            ".ssh"
            ".local/share/nvim"
            ".local/state/nvim"
            ".local/state/wireplumber"
            ".gnupg"
	];
	allowOther = true;
    };
    imports = [
        ./browser.nix
        ./waybar.nix
	inputs.impermanence.nixosModules.home-manager.impermanence
    ];
    programs.neovim.enable = true;
    programs.neovim.defaultEditor = true;
    programs.neovim.withPython3 = true;
    programs.neovim.viAlias = true;
    home.packages = [
        pkgs.noto-fonts
            pkgs.noto-fonts-emoji
            (pkgs.nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];
    programs.rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
        plugins = [pkgs.rofi-calc];
    };
    
    programs.lf = {
        enable = true;
        commands = {
            mkdir = ''
                ''${{
                    printf "Directory Name: "
                        read DIR
                        mkdir $DIR
                }}
            '';
        };
        keybindings = {
            o = "";
            c = "mkdir";
        };
    };

    programs.home-manager.enable = true;

    

    home.file = let 
        background = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/MarchCraft/Wallpaper/master/Untitled.png";
          hash = "sha256-iyH4aO4SfzkxdlpDdLH11D9iBRwIn1+nZEs9bY6ccU4=";
        };
    in {
        ".config/swaylock/config".source = ../../config/swaylock/config;
        ".config/kitty/kitty.conf".source = ../../config/kitty/kitty.conf;
        ".config/starship.toml".source = ../../config/starship.toml;
        ".config/nvim" = {
            source = ../../config/nvim;
            recursive = true;
        };
        ".config/rofi" = {
            source = ../../config/rofi;
            recursive = true;
        };
        ".config/fastfetch/config.jsonc".source = ../../config/fastfetch/config.jsonc;
        ".config/hypr/hyprland.conf" = {
            text = (builtins.readFile ../../config/hypr/hyprland.conf) + ''
                exec-once = sleep 1 && swww img --transition-type none ${background}
            '';
        };
        ".config/fish" = {
            source = ../../config/fish;
            recursive = true;
        };
        ".config/iamb" = {
            source = ../../config/iamb;
            recursive = true;
        };
        ".icons" = {
            source = ../../config/.icons;
            recursive = true;
        };
    };
    gtk = {
        enable = true;
        theme = {
            name = "Dracula";
            package = pkgs.materia-theme;
        };
        iconTheme = {
            package = pkgs.gnome.adwaita-icon-theme;
            name = "adwaita-icon-theme";
        };
    };
    programs.git = {
        enable = true;
        userName  = "Felix Nilles";
        userEmail = "felix@dienilles.de";
        signing = {
            key = "BF91E7F996966393DF5992FE15215F777DC602FC";
            signByDefault = true;
        };
    };
}
