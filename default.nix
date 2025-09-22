# Copyright : (c) 2022 Composewell Technologies

{
nixpkgs ? import

#------------------------------------------------------------------------------
# Modify the version in this line to change the nixpkgs version
#------------------------------------------------------------------------------

(builtins.fetchTarball
  https://github.com/NixOS/nixpkgs/archive/refs/tags/branch-off-24.11.tar.gz
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
, compiler ? "ghc96"

# To disable installation of editors: nix-shell --arg editors false
, editors ? true

# To disable installation haskell tools (hls etc):
# nix-shell --arg haskell-tools false
, haskell-tools ? true

# To disable hoogle search engine database: nix-shell --arg hoogle false
, hoogle ? true

}:

let

#------------------------------------------------------------------------------
# Haskell libraries, packages pre-installed in the nix shell
# Add or remove as you wish, any hackage package in nixpkgs set can be used.
#------------------------------------------------------------------------------

installedDeps =
  with hpkgs;
    [ # Streamly packages
      fusion-plugin
      streamly
      streamly-bytestring
      streamly-core
      streamly-coreutils
      streamly-filepath
      streamly-fsevents
      streamly-process
      streamly-statistics
      streamly-text

      ## Additional packages
      hspec
      tasty-bench
      ghczdecode
    ];

#------------------------------------------------------------------------------
# The versions of Haskell packages used are defined in nix/haskellPackages.nix
#------------------------------------------------------------------------------

haskellPackages =
  (import ./nix/haskellPackages.nix)
    { inherit nixpkgs;
      inherit compiler;
    };

#------------------------------------------------------------------------------
# TODO
#------------------------------------------------------------------------------

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

#------------------------------------------------------------------------------
# Vim editor configuration
#------------------------------------------------------------------------------

vimCfg = import nix/vim/vim.nix {nixpkgs = nixpkgs;};

#------------------------------------------------------------------------------
# VScode editor configuration
#------------------------------------------------------------------------------

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

#------------------------------------------------------------------------------
# other packages: haskell tools, editors, language server etc.
#------------------------------------------------------------------------------

otherPackages =
    [ nixpkgs.pkgs.cabal-install
      nixpkgs.pkgs.par                     # paragraph formatting for vim
      nixpkgs.pkgs.powerline-fonts         # for vim status line
      vimCfg.nvimCustom
    ] ++
      ( if (haskell-tools)
        then
        [ #nixpkgs.pkgs.hlint
          #nixpkgs.haskellPackages.fourmolu
          #nixpkgs.pkgs.ghcid
          hpkgs.haskell-language-server
        ] else []
      ) ++
      ( if (editors)
        then [ vscodium ]
        else []
      );

#------------------------------------------------------------------------------
# Additional library, setup and executable dependencies
#------------------------------------------------------------------------------

# A fake package to add some additional deps to the shell env
additionalDeps = hpkgs.mkDerivation rec {
    version = "0.1";
    pname   = "streamly-additional";
    license = "BSD-3-Clause";

    libraryHaskellDepends = installedDeps;
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

#------------------------------------------------------------------------------
# Import nix utility functions
#------------------------------------------------------------------------------

utils = (import ./nix/utils.nix) { inherit nixpkgs; };

#------------------------------------------------------------------------------
# Define the nix shell using haskell packages, additional deps and other
# packages.
#------------------------------------------------------------------------------

in if nixpkgs.lib.inNixShell
   then utils.mkShell hpkgs (p: [additionalDeps]) otherPackages hoogle true
   else abort "nix-shell only please!"
