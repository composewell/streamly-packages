# Copyright   : (c) 2022 Composewell Technologies
{ nixpkgs, system }:
with
    (import ./make-overrides.nix)
      {
        inherit nixpkgs;
        inherit system;
      };

let
  mkShell = shellDrv: pkgs: otherPkgs: doHoogle: doBench:
    shellDrv.shellFor {
      packages = pkgs;
      # some dependencies of hoogle fail to build with quickcheck-2.14
      # We should use hoogle as external tool instead of building it here
      withHoogle = doHoogle;
      doBenchmark = doBench;
      # XXX On macOS cabal2nix does not seem to generate a dependency on
      # Cocoa framework.
      buildInputs = otherPkgs ++ cocoa;
      # Use a better prompt
      shellHook = ''
        #CFG_DIR="$HOME/.config/streamly-packages"
        #CFG_FILE="$CFG_DIR/config.empty"
        #mkdir -p "$CFG_DIR"
        #export CABAL_DIR="$CFG_DIR"
        export CABAL_CONFIG=/dev/null
        #This is commented for hls to work with VSCode
        #cabal user-config update -a "jobs: 1"
        export PS1="$PS1(haskell) "
      '';
    };

in
{
  inherit mkShell;
  inherit cocoa;
}
