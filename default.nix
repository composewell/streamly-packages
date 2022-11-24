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

    haskellLibDeps =
      with hpkgs;
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

    vimCfg = import nix/vim/vim.nix {nixpkgs = nixpkgs;};
    otherPackages =
        [
          nixpkgs.pkgs.par                     # paragraph formatting for vim
          nixpkgs.pkgs.powerline-fonts # for git prompt, vim status line, make it a dep.
          vimCfg.nvimCustom

          nixpkgs.pkgs.cabal-install
          nixpkgs.pkgs.hlint
          nixpkgs.haskellPackages.fourmolu
          nixpkgs.pkgs.ghcid
          hpkgs.haskell-language-server
        ];

#------------------------------------------------------------------------------
# Generic stuff
#------------------------------------------------------------------------------

    haskellPackages =
      (import ./nix/haskellPackages.nix)
        { inherit nixpkgs;
          inherit compiler;
        };

    hpkgs =
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
    additionalDeps = hpkgs.mkDerivation rec {
              version = "0.1";
              pname   = "streamly-additional";
              license = "BSD-3-Clause";

              libraryHaskellDepends = haskellLibDeps;
              setupHaskellDepends = with hpkgs; [
                cabal-doctest
              ];
              executableFrameworkDepends = with hpkgs;
                # XXX On macOS cabal2nix does not seem to generate a
                # dependency on Cocoa framework.
                if builtins.currentSystem == "x86_64-darwin"
                then [nixpkgs.darwin.apple_sdk.frameworks.Cocoa]
                else [];
            };

    utils =
      (import ./nix/utils.nix)
        { inherit nixpkgs; };

in if nixpkgs.lib.inNixShell
   then utils.mkShell hpkgs (p: [additionalDeps]) otherPackages true
   else abort "nix-shell only please!"
