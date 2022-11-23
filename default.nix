# Copyright   : (c) 2022 Composewell Technologies
# License     : All rights reserved.

# CAUTION! a spelling mistake in arg string is ignored silently.
#
# To use ghc-8.10.7
# nix-shell --argstr compiler "ghc8107"

{
  nixpkgs ?
    import (builtins.fetchTarball
      https://github.com/NixOS/nixpkgs/archive/refs/tags/22.05.tar.gz)
        {}
, compiler ? "ghc922"
}:
let

#------------------------------------------------------------------------------
# Packages available in the nix shell
#------------------------------------------------------------------------------

    shellPkgs =
      with shell;
        [ # Streamly packages
          fusion-plugin
          streamly-core
          streamly
          #streamly-bytestring
          #streamly-examples
          streamly-coreutils
          #streamly-lz4
          streamly-metrics
          streamly-process
          streamly-shell
          streamly-statistics

          # Additional packages
          hspec
          tasty-bench
        ];

#------------------------------------------------------------------------------
# Generic stuff
#------------------------------------------------------------------------------

    haskellPackages =
      (import ./haskellPackages.nix)
        { inherit nixpkgs;
          inherit compiler;
        };

    shell =
      haskellPackages.override (old: {
        overrides =
          nixpkgs.lib.composeExtensions
            (old.overrides or (_: _: {}))
            (with nixpkgs.haskell.lib; self: super: {
              # Add local packages here
              # XXX Uses src = null, need to fix
              #streamly = local super "streamly" ./. flags inShell;
            });
      });

    # A fake package to add some additional deps to the shell env
    additionalDeps = shell.mkDerivation rec {
              version = "0.1";
              pname   = "streamly-additional";
              license = "BSD-3-Clause";

              libraryHaskellDepends = shellPkgs;
              setupHaskellDepends = with shell; [
                cabal-doctest
              ];
              executableFrameworkDepends = with shell;
                # XXX On macOS cabal2nix does not seem to generate a
                # dependency on Cocoa framework.
                if builtins.currentSystem == "x86_64-darwin"
                then [nixpkgs.darwin.apple_sdk.frameworks.Cocoa]
                else [];
            };

    utils =
      (import ./utils.nix)
        { inherit nixpkgs; };

in if nixpkgs.lib.inNixShell
   then utils.mkShell shell (p: [additionalDeps]) true
   else abort "nix-shell only please!"
