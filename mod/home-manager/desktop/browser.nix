{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    inputs.betterfox.homeManagerModules.betterfox
  ];

  options.marchcraft.desktop.apps.firefox = {
    enable = lib.mkEnableOption "install 0x5a4s firefox config";
    makeDefault = lib.mkEnableOption "make firefox the default browser";
  };

  config =
    let
      opts = config.marchcraft.desktop.apps.firefox;
    in
    lib.mkIf opts.enable {
      stylix.targets.firefox.profileNames = [ "main" ];
      programs.firefox = {
        enable = true;

        betterfox.enable = true;

        policies = {
          "DisableFormHistory" = true;
          "DisableFirefoxAccounts" = true;
          "DontCheckDefaultBrowser" = true;
          "NetworkPrediction" = false;
          "CaptivePortal" = false;
          "DNSOverHTTPS" = {
            "Enabled" = true;
          };
          "DisableFirefoxStudies" = true;
          "DisableTelemetry" = true;
          "DisablePocket" = true;
          "OfferToSaveLogins" = false;
          "HttpsOnlyMode" = "enabled";
          "SanitizeOnShutdown" = {
            "History" = true;
            "Cookies" = true;
          };
          "Cookies" = {
            "Allow" = [
              "https://youtube.com"
              "https://netflix.com"
              "https://github.com"
              "https://disneyplus.com"
              "https://hhu.de"
            ];
            "Behaviour" = "reject";
          };
          "Extensions" = {
            "Uninstall" = [
              "google@search.mozilla.org"
              "bing@search.mozilla.org"
              "amazondotcom@search.mozilla.org"
              "ebay@search.mozilla.org"
              "twitter@search.mozilla.org"
            ];
          };
        };

        profiles.main = {
          betterfox = {
            enable = true;
            enableAllSections = true;
          };

          bookmarks =
            let
              define = url: {
                name = "";
                url = "https://${url}";
              };
              defineNamed = name: url: {
                name = name;
                url = "https://${url}";
              };
              folder = name: bookmarks: {
                name = name;
                bookmarks = bookmarks;
              };
            in
            {
              force = true;
              settings = [
                {
                  name = "toolbar";
                  toolbar = true;
                  bookmarks = [
                    (define "youtube.com")
                    (define "disneyplus.com/en-de")
                    (define "nixos.wiki")
                    (define "github.com")
                    (define "crates.io")
                    (folder "tools" [
                      (defineNamed "craiyon" "craiyon.com")
                      (defineNamed "hex to dec" "www.rapidtables.com/convert/number/hex-to-decimal.html")
                      (defineNamed "goodname" "kampersanda.github.io/goodname")
                      (defineNamed "plotz" "www.plotz.co.uk")
                      (defineNamed "toml validator" "www.toml-lint.com")
                      (defineNamed "click" "clickclickclick.click/#4a955f9cf0bbe3854fa9ede6935d540c")
                      (defineNamed "mems" "imgflip.com/memegenerator")
                    ])
                    (folder "uni" [
                      (defineNamed "ilias" "ilias.hhu.de/login.php?client_id=UniRZ&cmd=force_login&lang=de")
                      (defineNamed "lsf" "lsf.hhu.de")
                      (defineNamed "fscs" "fscs.hhu.de")
                      (defineNamed "phynix-hhu nextcloud" "nextcloud.phynix-hhu.de")
                      (defineNamed "sitzungsverwaltung" "sitzungen.hhu-fscs.de")
                      (defineNamed "tickets" "tickets.astahhu.de/mailbox/4")
                    ])
                    (folder "doc" [
                      (defineNamed "lua 5.4 reference" "www.lua.org/manual/5.4")
                      (defineNamed "hyprland wiki" "wiki.hyprland.org")
                      (defineNamed "opencomputers" "ocdoc.cil.li")
                      (defineNamed "hugo" "gohugo.io/documentation")
                      (defineNamed "bootstrap" "getbootstrap.com/docs/")
                      (defineNamed "nixpkgs doc" "ryantm.github.io/nixpkgs/")
                    ])
                  ];
                }
              ];
            };

          search = {
            default = "ddg";
            force = true;
            engines =
              let
                define = alias: url: iconURL: {
                  urls = [ { template = "https://${url}"; } ];
                  icon = "https://${iconURL}";
                  updateInterval = 24 * 60 * 60 * 1000;
                  definedAliases = [ "@${alias}" ];
                };
              in
              {
                "Youtube" =
                  define "yt" "youtube.com/results?search_query={searchTerms}"
                    "www.youtube.com/favicon.ico";
                "Nix Packages" =
                  define "nixpkg" "search.nixos.org/packages?query={searchTerms}"
                    "nixos.wiki/favicon.png";
                "Nix Options" =
                  define "nixopt" "search.nixos.org/options?query={searchTerms}"
                    "nixos.wiki/favicon.png";
                "Home Manager Options" =
                  define "homeopt" "home-manager-options.extranix.com/?query={searchTerms}"
                    "nixos.wiki/favicon.png";
                "Searchix" =
                  define "searchix" "https://searchix.alanpearce.eu/all/search?query={searchTerms}"
                    "nixos.wiki/favicon.png";
                "Nix Wiki" = define "nixwiki" "nixos.wiki/index.php?search={searchTerms}" "nixos.wiki/favicon.png";
                "Crates.io" = define "crates" "crates.io/search?q={searchTerms}" "crates.io/favicon.ico";
                "Github" =
                  define "gh" "github.com/search?q={searchTerms}&type=repositories"
                    "github.com/favicon.ico";
                "Instant Gaming" =
                  define "ig" "www.instant-gaming.com/en/search/?q={searchTerms}"
                    "www.instant-gaming.com/favicon.ico";
                "ProtonDB" =
                  define "protondb" "www.protondb.com/search?q={searchTerms}"
                    "www.protondb.com/favicon.ico";
                "Modrinth" =
                  define "modrinth" "www.modrinth.com/mods?q={searchTerms}"
                    "www.modrinth.com/favicon.ico";
                "Arch" =
                  define "arch" "wiki.archlinux.org/index.php?search={searchTerms}"
                    "wiki.archlinux.org/favicon.ico";
                "google".metaData.hidden = true;
                "Amazon.de".metaData.hidden = true;
                "Twitter".metaData.hidden = true;
              };
          };

          extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
            bitwarden
            boring-rss
            clearurls
            darkreader
            decentraleyes
            don-t-fuck-with-paste
            enhanced-github
            enhanced-h264ify
            github-file-icons
            istilldontcareaboutcookies
            modrinthify
            multi-account-containers
            no-pdf-download
            passbolt
            privacy-possum
            return-youtube-dislikes
            smart-referer
            ublock-origin
            user-agent-string-switcher
          ];

          settings = {
            "extensions.autoDisableScopes" = 0;
            "browser.translations.automaticallyPopup" = false;
            "media.gmp-widevinecdm.version" = "system-installed";
            "media.gmp-widevinecdm.visible" = true;
            "media.gmp-widevinecdm.enabled" = true;
            "media.gmp-widevinecdm.autoupdate" = false;

            "media.eme.enabled" = true;
            "media.eme.encrypted-media-encryption-scheme.enabled" = true;
          };
        };
      };
    };
}
