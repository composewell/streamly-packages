{ nixpkgs, compiler, system, hoogle }:
let

  utils = (import ./utils.nix) {
    inherit nixpkgs;
    inherit system;
  };

  utils1 = (import ./make-overrides.nix) {
    inherit nixpkgs;
    inherit system;
    withHaddock = hoogle;
  };

  haskellPackagesOrig = if compiler == "default" then
    nixpkgs.haskellPackages
  else
    nixpkgs.haskell.packages.${compiler};

  sources = import ../sources.nix;

  layer1 = let
    overrides = self: super: utils1.makeOverrides super sources.layer1;
    in haskellPackagesOrig.extend overrides;

  layer2 = hpkgs: let
    overrides = self: super: utils1.makeOverrides super sources.layer2;
    in hpkgs.extend overrides;

  layer3 = hpkgs: let
    overrides = self: super: utils1.makeOverrides super sources.layer3;
  in hpkgs.extend overrides;

  haskellPackages =
    let p = layer3 (layer2 layer1);
    in
      p.extend (self: super:
      with nixpkgs.haskell.lib;
      builtins.listToAttrs (map (name: {
        inherit name;
        value = doJailbreak super.${name};
      }) sources.jailbreaks));

  requiredPackages = import ../packages.nix
    { inherit nixpkgs;
      hpkgs = haskellPackages;
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

in {
  inherit shell;
  inherit haskellPackages;
}
