{
  description = "Composewell Open Source Packages";

  # XXX it downloads both of these on both systems.
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/de69d2ba6c70e747320df9c096523b623d3a4c35"; # nixpkgs-unstable
    #nixpkgs.url = "github:NixOS/nixpkgs/b2a3852bd078e68dd2b3dfa8c00c67af1f0a7d20"; # nixpkgs-25.05
    #nixpkgs.url = "github:NixOS/nixpkgs/branch-off-24.11";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/c3d456aad3a84fcd76b4bebf8b48be169fc45c31"; # nixpkgs-25.05-darwin
    # For local testing use "path:.../nixpack";
    nixpack.url = "github:composewell/nixpack/e50da53dfcf24085fff75149a266646b28bd18fb";
  };

  outputs = { self, nixpkgs, nixpkgs-darwin, nixpack }:
    nixpack.flakeOutputs {
      inherit nixpkgs;
      inherit nixpkgs-darwin;
      inherit nixpack;
      nixpkgsOptions = {
            config.allowUnfree = true;
            config.allowBroken = true;
          };
      envOptions = {
            name = "composewell-env";
            sources = import ./sources.nix {inherit nixpack;};
            packages = import ./packages.nix;
            compiler = "default";
            hoogle = false;
            isDev = true;
      };
    } // { inherit nixpack;} ;
}
