{
nixpkgs ? import

#------------------------------------------------------------------------------
# Modify the commit in this line to change the nixpkgs version
#------------------------------------------------------------------------------

(
let
  commit =
    if builtins.match ".*darwin.*" builtins.currentSystem != null
    # use https://channels.nixos.org/nixpkgs-25.05-darwin/git-revision
    then "c3d456aad3a84fcd76b4bebf8b48be169fc45c31"
    #stan fails to build for macOS on this one
    #then "branch-off-24.11" # nixpkgs 24.11
    # use https://channels.nixos.org/nixpkgs-25.05/git-revision
    #else "b2a3852bd078e68dd2b3dfa8c00c67af1f0a7d20";
    #else "50ab793786d9de88ee30ec4e4c24fb4236fc2674"; # nixpkgs 24.11
    else "branch-off-24.11"; # nixpkgs 24.11
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

# To use a specific ghc version: nix-shell --argstr compiler "ghc966"
, compiler ? "ghc96"

# To disable hoogle search engine database: nix-shell --arg hoogle false
, hoogle ? true
}:
let src =
      builtins.fetchTarball {
        url = "https://github.com/composewell/nixpack/archive/59fdf661cb2f7df0.tar.gz";
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
