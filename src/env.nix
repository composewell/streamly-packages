{ nixpkgs, compiler, system, hoogle }:
let

utils = (import ./utils.nix) { inherit nixpkgs; inherit system; };
utils1 = (import ./make-overrides.nix) { inherit nixpkgs; inherit system; };

#------------------------------------------------------------------------------
# The versions of Haskell packages used are defined in nix/haskellPackages.nix
#------------------------------------------------------------------------------

haskellPackages =
let
    sources = import ../sources.nix;

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

in
    hpkgs.override {
      overrides = self: super:
        utils1.makeOverrides super sources;
    };

#------------------------------------------------------------------------------
# Vim editor configuration
#------------------------------------------------------------------------------

vimCfg = import ../vim/vim.nix {nixpkgs = nixpkgs;};

#------------------------------------------------------------------------------
# VScode editor configuration
#------------------------------------------------------------------------------

vscodiumCfg = import ../vscodium/vscodium.nix {inherit nixpkgs;};

#------------------------------------------------------------------------------
# other packages: haskell tools, editors, language server etc.
#------------------------------------------------------------------------------

otherPackages = import ../packages.nix
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
    # XXX On macOS cabal2nix does not seem to generate a
    # dependency on Cocoa framework.
    executableFrameworkDepends = utils.cocoa;
};

#------------------------------------------------------------------------------
# Define the nix shell using haskell packages, additional deps and other
# packages.
#------------------------------------------------------------------------------

in utils.mkShell haskellPackages (p: [additionalDeps]) otherPackages.packages hoogle true
