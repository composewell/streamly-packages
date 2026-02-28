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

# see https://channels.nixos.org/nixpkgs-25.05/git-revision
nixpkgsRev = "de69d2ba6c70e747320df9c096523b623d3a4c35"; # nixpkgs-unstable
# "b2a3852bd078e68dd2b3dfa8c00c67af1f0a7d20"; # nixpkgs 25.05
# "50ab793786d9de88ee30ec4e4c24fb4236fc2674"; # nixpkgs 24.11
# "branch-off-24.11"; # nixpkgs 24.11

# see https://channels.nixos.org/nixpkgs-25.05-darwin/git-revision
nixpkgsDarwinRev = "08478b816182dc3cc208210b996294411690111d"; # nixpkgs-25.05-darwin
# stan fails to build for macOS on branch-off-24.11" # nixpkgs 24.11

nixpkgsOptions =
  {
    config.allowUnfree = true; # Allow unfree packages for some vscode extensions
    config.allowBroken = true;
  };

#------------------------------------------------------------------------------
# nixpack configuration
#------------------------------------------------------------------------------

packName = "nixpack-composewell";
packOptions =
  { inherit compiler;
    inherit installHoogle;
    #installDocs = true;
  };

# https://github.com/composewell/nixpack repository revision.
# IMPORTANT: also change the revision bin/nix-outdated-pack.sh
nixpackRev = "c5058ba175f78a510edcfc5ccf5806ab533cc1c5";

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
