{
  lib,
  config,
  inputs,
  self,
  ...
}:
let
  cfg = config.stylix.testbed;
in
{
  options.stylix.testbed = {
    modules = lib.mkOption {
      type = lib.types.attrsOf lib.types.deferredModule;
      default = { };
      description = "A set of testbed modules to include in the flake.";
    };
  };

  config = {
    stylix.testbed.modules = import "${self}/stylix/testbed/get-modules.nix" {
      inherit lib;
    };

    perSystem = lib.mkIf (cfg.modules != { }) (
    { pkgs, config, ... }:
    {
      # Build all packages with 'nix flake check' instead of only verifying they
      # are derivations.
      checks = config.packages;

      # Testbeds are virtual machines based on NixOS, therefore they are
      # only available for Linux systems.
      packages = lib.mkIf pkgs.stdenv.hostPlatform.isLinux (
        import "${self}/stylix/testbed/default.nix" {
          inherit pkgs inputs lib;
          inherit (cfg) modules;
        }
      );
      }
    );

  };
}
