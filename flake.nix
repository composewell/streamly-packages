{
  description = "Composewell Open Source Packages";

  # XXX it downloads both of these on both systems.
  # IMPORTANT: if you change the commits, change in common.nix as well.
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/6c9a78c09ff4d6c21d0319114873508a6ec01655"; # nixos-unstable

    # Runs into error: darwin.apple_sdk_11_0 has been removed ...
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/6c9a78c09ff4d6c21d0319114873508a6ec01655"; # nixos-unstable
    #nixpkgs-darwin.url = "github:NixOS/nixpkgs/08478b816182dc3cc208210b996294411690111d"; # nixpkgs-25.05-darwin
    # For local testing use:
    # basepkgs.url = "path:/path/to/nixpack";
    basepkgs.url = "github:composewell/nixpack/f50a0b2aaaab434f46847bc171240957b508b901";
  };

  outputs = { self, nixpkgs, nixpkgs-darwin, basepkgs }:
    basepkgs.nixpack.mkOutputs {
      inherit nixpkgs;
      inherit nixpkgs-darwin;
      inherit basepkgs;
      name = "nixpack-composewell-open";
      sources = import ./sources.nix;
      packages = import ./packages.nix;
      # Use default to utilize the cache,
      # specific compiler for reproducibility
      #compiler = "default";
      #installHoogle = false;
      #installDocs = false;
    };
}
