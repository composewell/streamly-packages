{ nixpkgs, compiler, system, hoogle }:
let

  utils = (import ./utils.nix) {
    inherit nixpkgs;
    inherit system;
  };

  utils1 = (import ./make-overrides.nix) {
    inherit nixpkgs;
    inherit system;
  };

  haskellPackagesOrig = if compiler == "default" then
    nixpkgs.haskellPackages
  else
    nixpkgs.haskell.packages.${compiler};

  sources = import ../sources.nix;

haskellPackages =
    haskellPackagesOrig.override {
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

  requiredPackages = import ../packages.nix
    { pkgs = nixpkgs.pkgs;
      hpkgs = haskellPackages;
      vim = vimCfg.nvimCustom;
      vscodium = vscodiumCfg.vscodium;
    };

  # A fake package to add some additional deps to the shell env
  additionalDeps = haskellPackages.mkDerivation rec {
    version = "0.1";
    pname = "fake-shell-deps";
    license = "BSD-3-Clause";

    libraryHaskellDepends = requiredPackages.libraries;
    setupHaskellDepends = with haskellPackages; [ cabal-doctest ];
    # XXX On macOS cabal2nix does not seem to generate a
    # dependency on Cocoa framework.
    executableFrameworkDepends = utils.cocoa;
  };

  shell = utils.mkShell haskellPackages (p: [ additionalDeps ]) requiredPackages.packages hoogle true;

in shell
