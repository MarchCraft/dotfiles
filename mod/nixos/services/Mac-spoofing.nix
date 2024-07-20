{ lib
, config
, pkgs
, ...
}: {
  options.marchcraft.services.mac-spoofing = {
    enable = lib.mkEnableOption "setup mac-spoofing";
    interface = lib.mkOption {
      type = lib.types.str;
    };
  };
  config =
    let
      opts = config.marchcraft.services.mac-spoofing;
      change-mac = pkgs.writeShellScript "change-mac" ''
        		card=$1
        		tmp=$(mktemp)
        		${pkgs.macchanger}/bin/macchanger "$card" -s | grep -oP "[a-zA-Z0-9]{2}:[a-zA-Z0-9]{2}:[^ ]*" > "$tmp"
        		mac1=$(cat "$tmp" | head -n 1)
        		mac2=$(cat "$tmp" | tail -n 1)
        		if [ "$mac1" = "$mac2" ]; then
        			if [ "$(cat /sys/class/net/"$card"/operstate)" = "up" ]; then
        				${pkgs.iproute2}/bin/ip link set "$card" down &&
        				${pkgs.macchanger}/bin/macchanger -r "$card"
        				${pkgs.iproute2}/bin/ip link set "$card" up
        			else
        				${pkgs.macchanger}/bin/macchanger -r "$card"
        			fi
        		fi
        	'';
    in
    lib.mkIf opts.enable {
      environment.systemPackages = [
        pkgs.macchanger
      ];
      systemd.services.macchanger = {
        enable = true;
        description = "macchanger on ${opts.interface}";
        wants = [ "network-pre.target" ];
        before = [ "network-pre.target" ];
        bindsTo = [ "sys-subsystem-net-devices-${opts.interface}.device" ];
        after = [ "sys-subsystem-net-devices-${opts.interface}.device" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${change-mac} ${opts.interface}";
        };
      };
    };
}

