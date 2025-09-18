{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.autoenv;
in
{
  options = {
    programs.autoenv = {
      enable = lib.mkEnableOption "autoenv";
      package = lib.mkOption {
        type = with lib.types; package;
        default = pkgs.autoenv;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    programs = {
      zsh.interactiveShellInit = ''
        source ${cfg.package}/share/autoenv/activate.sh
      '';

      bash.interactiveShellInit = ''
        source ${cfg.package}/share/autoenv/activate.sh
      '';
    };
  };
}
