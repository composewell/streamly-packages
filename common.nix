{
nixpkgs ? import

#------------------------------------------------------------------------------
# Modify the commit in this line to change the nixpkgs version
#------------------------------------------------------------------------------

(
let
  commit =
    if builtins.match ".*darwin.*" builtins.currentSystem != null
    #see https://channels.nixos.org/nixpkgs-25.05-darwin/git-revision
    then "08478b816182dc3cc208210b996294411690111d" # nixpkgs-25.05-darwin
    #stan fails to build for macOS on this one
    #then "branch-off-24.11" # nixpkgs 24.11
    else "de69d2ba6c70e747320df9c096523b623d3a4c35"; # nixpkgs-unstable
    #see https://channels.nixos.org/nixpkgs-25.05/git-revision
    #else "b2a3852bd078e68dd2b3dfa8c00c67af1f0a7d20"; # nixpkgs 25.05
    #else "50ab793786d9de88ee30ec4e4c24fb4236fc2674"; # nixpkgs 24.11
    #else "branch-off-24.11"; # nixpkgs 24.11
in
  builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${commit}.tar.gz";
  }
)

#------------------------------------------------------------------------------
# nixpkgs options
#------------------------------------------------------------------------------

{
  config.allowUnfree = true; # Allow unfree packages for some vscode extensions
  config.allowBroken = true;
}

#------------------------------------------------------------------------------
# Optional arguments to the nix-shell
#------------------------------------------------------------------------------

# CAUTION! a spelling mistake in an arg string is ignored silently.

# We use the default compiler so that upon changing the nixpkgs channel we do
# not have to recompile the packages.

# To use a specific ghc version: nix-shell --argstr compiler "ghc966"
, compiler ? "default"

# To disable hoogle search engine database: nix-shell --arg hoogle false
, installHoogle ? false
}:
let src =
      builtins.fetchTarball {
        url = "https://github.com/composewell/nixpack/archive/796a47f5d9abd9f66c9340e2b9ff9aeed2af1389.tar.gz";
      };
    basepkgs = import src;

    nixpkgs1 = nixpkgs.extend (self: super: {
      # XXX we may not needs this if we are passing basepkgs everywhere
      nixpack = basepkgs.nixpack;
    });

in
    basepkgs.nixpack.mkEnv
      { nixpkgs = nixpkgs1;
        inherit basepkgs;
        name = "composewell-packages";
        sources = import ./sources.nix;
        packages = import ./packages.nix;
        inherit compiler;
        inherit installHoogle;
        #installDocs = false;
      }
