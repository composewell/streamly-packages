# Copyright   : (c) 2022 Composewell Technologies
#
# CAUTION! a spelling mistake in arg string is ignored silently.
#
# To use a specific ghc version:
# nix-shell --argstr compiler "ghc943"
# nix-shell --arg editors true --arg hoogle true

{
  nixpkgs ?
    import (builtins.fetchTarball
      https://github.com/NixOS/nixpkgs/archive/refs/tags/23.11.tar.gz)
      # 23.05-pre
      #https://github.com/NixOS/nixpkgs/archive/b68bd2e.tar.gz)
      # Unfree for some vscode extensions
        { config.allowUnfree = true;
        }
, compiler ? "ghc96"
, editors ? true
, haskell-tools ? true
, hoogle ? true
, all ? false
}:

let

#------------------------------------------------------------------------------
# Packages available in the nix shell
#------------------------------------------------------------------------------

    haskellLibDeps =
      with hpkgs;
        [ # Streamly packages
          #fusion-plugin
          #streamly-core
          #streamly
          ##streamly-bytestring
          #streamly-examples
          #streamly-coreutils
          ##streamly-lz4
          #streamly-metrics
          #streamly-process
          #streamly-shell
          #streamly-statistics

          ## Additional packages
          #hspec
          #tasty-bench
          #ghczdecode
        ];

    vimCfg = import nix/vim/vim.nix {nixpkgs = nixpkgs;};
    vscodium =
      nixpkgs.pkgs.vscode-with-extensions.override
        { vscode = nixpkgs.pkgs.vscodium;
          vscodeExtensions =
            with nixpkgs.pkgs.vscode-extensions;
            # Extensions from
            # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vscode/extensions/default.nix
            [
              # Needs to be installed explicitly for haskell.haskell to work
              justusadam.language-haskell
              haskell.haskell
              #ms-vscode-remote.remote-ssh # unfree
            ]
            # Extensions from marketplace
            ++ nixpkgs.pkgs.vscode-utils.extensionsFromVscodeMarketplace
            [
              #{
              #  name = "";
              #  publisher = "";
              #  version = "";
              #  sha256 = "";
              #}
            ];
        };

    otherPackages =
        [ nixpkgs.pkgs.cabal-install

          nixpkgs.pkgs.par                     # paragraph formatting for vim
          nixpkgs.pkgs.powerline-fonts         # for vim status line
          vimCfg.nvimCustom
        ] ++
          ( if (all || haskell-tools)
            then
            [ #nixpkgs.pkgs.hlint
              #nixpkgs.haskellPackages.fourmolu
              #nixpkgs.pkgs.ghcid
              hpkgs.haskell-language-server
            ] else []
          ) ++
          ( if (all || editors)
            then [ vscodium ]
            else []
          );

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
   then
      utils.mkShell
        hpkgs (p: [additionalDeps]) otherPackages (all || hoogle) true
   else abort "nix-shell only please!"
