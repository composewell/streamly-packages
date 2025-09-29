{
  description = "Development Environment";

  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/branch-off-24.11"; };

  outputs = { self, nixpkgs }:

    let
      systems = [ "x86_64-linux" "x86_64-darwin" ];

      # TODO: Move this as a lower level helper module
      forAllSystems = f:
        builtins.listToAttrs (map (system: {
          name = system;
          value = f system;
        }) systems);

      mkEnv = system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            config.allowBroken = true;
          };
          compiler = "ghc96";
          env = import ./src/env.nix {
            nixpkgs = pkgs;
            inherit compiler;
            inherit system;
            hoogle = true;
          };
        in env;

    in {
      devShells = forAllSystems (system: { default = (mkEnv system).shell; });
      # This provides a central repository of executables that we can build and
      # install. We can avoid having individual flake files across multiple
      # repositories.
      packages = forAllSystems (system: (mkEnv system).haskellPackages);
    };

}
