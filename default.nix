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
# not have to recompile the compiler.

# To use a specific ghc version: nix-shell --argstr compiler "ghc966"
, compiler ? "default"

# To disable hoogle search engine database: nix-shell --arg hoogle false
, hoogle ? false
}:
let src =
      builtins.fetchTarball {
        url = "https://github.com/composewell/nixpack/archive/e50da53dfcf24085fff75149a.tar.gz";
      };
    nixpack = import "${src}/nix";

    nixpkgs1 = nixpkgs.extend (self: super: {
      nixpack = nixpack;
    });

    env =
      nixpack.mkEnv
        { nixpkgs = nixpkgs1;
          name = "streamly-packages";
          sources = import ./sources.nix {inherit nixpack;};
          packages = import ./packages.nix;
          inherit compiler;
          inherit hoogle;
          isDev = true;
        };
in if nixpkgs.lib.inNixShell
   then env.shell
   else env.env
