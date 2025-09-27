# Copyright : (c) 2022 Composewell Technologies

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
}

#------------------------------------------------------------------------------
# Optional arguments to the nix-shell
#------------------------------------------------------------------------------

# CAUTION! a spelling mistake in an arg string is ignored silently.

# To use a specific ghc version: nix-shell --argstr compiler "ghc966"
, compiler ? "default"

# To disable installation of editors: nix-shell --arg editors false
#, editors ? true

# To disable installation haskell tools (hls etc):
# nix-shell --arg haskell-tools false
#, haskell-tools ? true

# To disable hoogle search engine database: nix-shell --arg hoogle false
, hoogle ? true

}:

let

#------------------------------------------------------------------------------
# The versions of Haskell packages used are defined in nix/haskellPackages.nix
#------------------------------------------------------------------------------

haskellPackages =
let
    utils = (import ./nix/utils.nix) { inherit nixpkgs; };

    sources = import ./nix/haskellPackages.nix;

    hpkgs =
        if compiler == "default"
        then nixpkgs.haskellPackages
        else nixpkgs.haskell.packages.${compiler};

    #recompile = pkg:
    #    pkg.overrideAttrs (oldAttrs:
    #      { doCheck = false;
    #        #doHaddock = false;
    #        configureFlags =
    #          oldAttrs.configureFlags ++ ["--disable-tests"];
    #      });

    makeOverrides = utils: super: sources:
      builtins.mapAttrs (name: spec:
        if spec.type == "hackage" then
          utils.hackage super name spec.version spec.sha256
        else if spec.type == "github" then
          utils.github super "${spec.owner}/${spec.repo}" spec.rev
        else
          throw "Unknown package source type: ${spec.type}"
      ) sources;

in
    hpkgs.override {
      overrides = self: super:
        makeOverrides utils super sources;
    };

#------------------------------------------------------------------------------
# TODO
#------------------------------------------------------------------------------

#haskellPackages1 =
#  haskellPackages.override (old: {
#    overrides =
#      nixpkgs.lib.composeExtensions
#        (old.overrides or (_: _: {}))
#        (with nixpkgs.haskell.lib; self: super: {
#          # Add local packages here
#          # XXX Uses src = null, need to fix
#          #streamly = local super "streamly" ./. flags inShell;
#        });
#  });

#------------------------------------------------------------------------------
# Vim editor configuration
#------------------------------------------------------------------------------

vimCfg = import vim/vim.nix {nixpkgs = nixpkgs;};

#------------------------------------------------------------------------------
# VScode editor configuration
#------------------------------------------------------------------------------

vscodiumCfg = import vscodium/vscodium.nix {inherit nixpkgs;};

#------------------------------------------------------------------------------
# other packages: haskell tools, editors, language server etc.
#------------------------------------------------------------------------------

otherPackages = import ./packages.nix
  { pkgs = nixpkgs.pkgs;
    hpkgs = haskellPackages;
    vim = vimCfg.nvimCustom;
    vscodium = vscodiumCfg.vscodium;
  };

#------------------------------------------------------------------------------
# Additional library, setup and executable dependencies
#------------------------------------------------------------------------------

# A fake package to add some additional deps to the shell env
additionalDeps = haskellPackages.mkDerivation rec {
    version = "0.1";
    pname   = "streamly-additional";
    license = "BSD-3-Clause";

    libraryHaskellDepends = otherPackages.libraries;
    setupHaskellDepends = with haskellPackages; [
      cabal-doctest
    ];
    executableFrameworkDepends = with haskellPackages;
      # XXX On macOS cabal2nix does not seem to generate a
      # dependency on Cocoa framework.
      if builtins.match ".*darwin.*" builtins.currentSystem != null
      then [nixpkgs.darwin.apple_sdk.frameworks.Cocoa]
      else [];
};

#------------------------------------------------------------------------------
# Import nix utility functions
#------------------------------------------------------------------------------

utils = (import ./nix/utils.nix) { inherit nixpkgs; };

#------------------------------------------------------------------------------
# Define the nix shell using haskell packages, additional deps and other
# packages.
#------------------------------------------------------------------------------

in utils.mkShell haskellPackages (p: [additionalDeps]) otherPackages.packages hoogle true
