{
  description = "Composewell Open Source Packages";

  # XXX it downloads both of these on both systems.
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/de69d2ba6c70e747320df9c096523b623d3a4c35"; # nixpkgs-unstable
    #nixpkgs.url = "github:NixOS/nixpkgs/b2a3852bd078e68dd2b3dfa8c00c67af1f0a7d20"; # nixpkgs-25.05
    #nixpkgs.url = "github:NixOS/nixpkgs/branch-off-24.11";

    # Runs into error: darwin.apple_sdk_11_0 has been removed ...
    #nixpkgs-darwin.url = "github:NixOS/nixpkgs/e99366c665bdd53b7b500ccdc5226675cfc51f45"; # nixpkgs-unstable
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/08478b816182dc3cc208210b996294411690111d"; # nixpkgs-25.05-darwin
    # For local testing use "path:.../nixpack";
    basepkgs.url = "github:composewell/nixpack/a2a724eab0a2d09dc19ef773c017678364632baa";
  };

  outputs = { self, nixpkgs, nixpkgs-darwin, basepkgs }:
    basepkgs.nixpack.mkOutputs {
      inherit nixpkgs;
      inherit nixpkgs-darwin;
      inherit basepkgs;
      name = "composewell-env";
      sources = import ./sources.nix;
      packages = import ./packages.nix;
      #compiler = "default";
      #hoogle = false;
    };
}
