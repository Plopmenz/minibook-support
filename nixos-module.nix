{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.minibook-support;
  package = pkgs.callPackage ./package.nix { };
in
{
  options = {
    services.minibook-support = {
      enable = lib.mkEnableOption "Enable minibook support.";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.kernelParams = [
      "fbcon=rotate:1"
    ];
    services.xserver.displayManager.setupCommands = ''
      ${lib.getExe pkgs.xrandr} --output DSI-1 --rotate right
    '';

    hardware.sensor.iio.enable = true;

    systemd.services = {
      keyboardd = {
        description = "Daemon for the keyboardd of the MiniBook";
        requires = [ "sysinit.target" ];
        after = [
          "sysinit.target"
          "basic.target"
        ];
        serviceConfig = {
          ExecStart = "${package}/bin/keyboardd";
          Restart = "no";
          Type = "simple";
        };
        wantedBy = [ "multi-user.target" ];
      };
      moused = {
        description = "Daemon for the mouse of the MiniBook";
        requires = [ "sysinit.target" ];
        after = [
          "sysinit.target"
          "basic.target"
        ];
        serviceConfig = {
          ExecStart = "${package}/bin/moused -c";
          Restart = "no";
          Type = "simple";
        };
        wantedBy = [ "multi-user.target" ];
      };
      tabletmoded = {
        description = "Daemon for the tabletmode of the MiniBook";
        requires = [
          "moused.service"
          "keyboardd.service"
          "sysinit.target"
        ];
        after = [
          "moused.service"
          "keyboardd.service"
          "iio-sensor-proxy.service"
          "sysinit.target"
          "basic.target"
        ];
        serviceConfig = {
          ExecStart = "${package}/bin/tabletmoded";
          Restart = "no";
          Type = "simple";
        };
        wantedBy = [ "multi-user.target" ];
      };
    };
  };
}
