{
  description = "Development Environment";

  inputs = {
    # nixpkgs-linux.url = "github:NixOS/nixpkgs/branch-off-24.11";
    nixpkgs-linux.url = "github:NixOS/nixpkgs/b2a3852bd078e68dd2b3dfa8c00c67af1f0a7d20"; # nixpkgs-25.05
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/c3d456aad3a84fcd76b4bebf8b48be169fc45c31"; # nixpkgs-25.05-darwin
  };

  outputs = { self, nixpkgs-linux, nixpkgs-darwin }:

    let

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      # TODO: Move this as a lower level helper module
      forAllSystems = f:
        builtins.listToAttrs (map (system: {
          name = system;
          value = f system;
        }) systems);

      mkEnv = system:
        let
          nixpkgs =
            if builtins.match ".*darwin.*" system != null
            then nixpkgs-darwin
            else nixpkgs-linux;
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
