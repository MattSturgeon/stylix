{
  pkgs,
  inputs,
  lib,
  ...
}:

let
  testbedFieldSeparator = ":";

  # Creates a minimal configuration to extract the `stylix.testbed.enable`
  # option value.
  #
  # This is for performance reasons. Primarily, to avoid fully evaluating
  # testbed system configurations to determine flake outputs.
  # E.g., when running `nix flake show`.
  isEnabled =
    module:
    let
      minimal = lib.evalModules {
        modules = [
          module
          ./modules/enable.nix
          { _module.check = false; }
          { _module.args = { inherit pkgs; }; }
        ];
      };
    in
    minimal.config.stylix.testbed.enable;

  autoload =
    let
      directory = "testbeds";
      modules = ../modules;
    in
    lib.pipe modules [
      builtins.readDir
      builtins.attrNames
      (builtins.concatMap (
        module:
        let
          testbeds = modules + "/${module}/${directory}";
          files = lib.optionalAttrs (builtins.pathExists testbeds) (
            builtins.readDir testbeds
          );
        in
        lib.mapAttrsToList (
          testbed: type:
          if type != "regular" then
            throw "${testbed} must be regular: ${type}"

          else if !lib.hasSuffix ".nix" testbed then
            throw "testbed must be a Nix file: ${toString testbeds}/${testbed}"

          else if testbed == ".nix" then
            throw "testbed must have a name: ${testbed}"

          else
            {
              inherit module;

              name = lib.removeSuffix ".nix" testbed;
              path = testbeds + "/${testbed}";
            }
        ) files
      ))
    ];

  makeTestbed =
    testbed: testcase: stylix:
    let
      name =
        lib.concatMapStringsSep testbedFieldSeparator
          (
            field:
            lib.throwIf (lib.hasInfix testbedFieldSeparator field)
              "testbed field must not contain the '${testbedFieldSeparator}' testbed field separator: ${field}"
              field
          )
          [
            "testbed"
            testbed.name
            testcase
          ];

    in
    lib.optionalAttrs (isEnabled testbed.path) {
      ${name} = testbed.path;
    };

  # This generates a copy of each testbed for each of the imported themes.
  makeTestbeds =
    testbed:
    lib.mapAttrsToList (makeTestbed testbed) (
      import ./themes.nix {
        inherit (inputs) tinted-schemes;
        inherit (pkgs) vanilla-dmz;
        images = pkgs.callPackages ./images.nix { };
      }
    );

in
# Testbeds are merged using lib.attrsets.unionOfDisjoint to throw an error if
# testbed names collide.
builtins.foldl' lib.attrsets.unionOfDisjoint { } (
  builtins.concatMap makeTestbeds autoload
)
