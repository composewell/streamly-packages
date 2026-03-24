{ nixpkgs ? null
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

let
#------------------------------------------------------------------------------
# nixpksg configuration
#------------------------------------------------------------------------------

# IMPORTANT: if you change the commits, change in flake.nix as well.

# see https://channels.nixos.org/nixos-unstable/git-revision
nixpkgsRev = "6c9a78c09ff4d6c21d0319114873508a6ec01655"; # nixos-unstable
nixpkgsDarwinRev = "6c9a78c09ff4d6c21d0319114873508a6ec01655"; # nixos-unstable

nixpkgsOptions =
  {
    config.allowUnfree = true; # Allow unfree packages for some vscode extensions
    config.allowBroken = true;
  };

#------------------------------------------------------------------------------
# nixpack configuration
#------------------------------------------------------------------------------

packName = "nixpack-composewell-open";
packOptions =
  { inherit compiler;
    inherit installHoogle;
    #installDocs = true;
  };

# https://github.com/composewell/nixpack repository revision.
nixpackRev = "bebbfc11f153bf3a95c5b9dda4980bf47451bff2";

#------------------------------------------------------------------------------
# Anything after this is usually not to be changed
#------------------------------------------------------------------------------

isDarwin = builtins.match ".*darwin.*" builtins.currentSystem != null;
commit = if isDarwin then nixpkgsDarwinRev else nixpkgsRev;

nixpkgsOrig =
  if nixpkgs != null
  then nixpkgs
  else
    import
      (
        builtins.fetchTarball {
          url = "https://github.com/NixOS/nixpkgs/archive/${commit}.tar.gz";
        }
      ) nixpkgsOptions;

basepkgs =
  let
    src =
        builtins.fetchTarball {
          url = "https://github.com/composewell/nixpack/archive/${nixpackRev}.tar.gz";
        };
  in import src;

nixpkgs1 = nixpkgsOrig.extend (self: super: {
  # XXX we may not need this if we are passing basepkgs everywhere
  nixpack = basepkgs.nixpack;
});

in

basepkgs.nixpack.mkEnv
  { nixpkgs = nixpkgs1;
    inherit basepkgs;
    name = packName;
    sources = import ./sources.nix;
    packages = import ./packages.nix;
  } // packOptions
