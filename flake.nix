{
  description = "Streamly Development Environment";

  # XXX it downloads both of these on both systems.
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/branch-off-24.11";
    #nixpkgs.url = "github:NixOS/nixpkgs/b2a3852bd078e68dd2b3dfa8c00c67af1f0a7d20"; # nixpkgs-25.05
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/c3d456aad3a84fcd76b4bebf8b48be169fc45c31"; # nixpkgs-25.05-darwin
    # For local testing use "path:.../nixpack";
    nixpack.url = "github:composewell/nixpack/59fdf661cb2f7df0929f89818a9dfcf6c6c23a78";
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
            hoogle = true;
            isDev = true;
      };
    } // { inherit nixpack;} ;
}
