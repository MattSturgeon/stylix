{ inputs, self, ... }:
{

  perSystem =
    { pkgs, config, ... }:
    {
      # Build all packages with 'nix flake check' instead of only verifying they
      # are derivations.
      checks = config.packages;

      packages = {
        docs = pkgs.callPackage "${self}/doc" {
          inherit inputs;
          inherit (inputs.nixpkgs.lib) nixosSystem;
          inherit (inputs.home-manager.lib) homeManagerConfiguration;
        };
        palette-generator = pkgs.callPackage "${self}/palette-generator" { };
      };
    };
}
