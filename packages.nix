{nixpkgs}:
let
  pkgs = nixpkgs.pkgs;
  hpkgs = nixpkgs.haskellPackages;
in
{
packages =
    [ # Editors
      hpkgs.nixpack-editors.nvimWithConfig
      hpkgs.nixpack-editors.vim_bashrc
      hpkgs.nixpack-editors.vim_gitconfig
      # Currently broken for macOS
      #hpkgs.nixpack-editors.vscodiumWithConfig

      # Haskell tools
      # From nixpkgs.pkgs
      pkgs.cabal-install
      # pkgs.hlint
      # pkgs.ghcid

      # From nixpkgs.haskellPackages
      hpkgs.haskell-language-server
      # hpkgs.fourmolu
      hpkgs.ghczdecode
    ];

libraries =
with nixpkgs.haskellPackages;

let hackage-packages = [
    # Core
    fusion-plugin
    streamly-core
    streamly

    # Compatibility
    streamly-bytestring
    streamly-text
    streamly-filepath

    # Higher level
    # on macOS fails with heap-overflow
    # streaming-benchmarks
    #streamly-examples
    streamly-fsevents
    streamly-process
    streamly-statistics
  ];

  pre-release-packages = [
    streamly-coreutils

    # dependent on streamly-process
    simple-rpc
    simple-rpc-generate

    packdiff

    bench-show
    # depends on streamly-coreutils, bench-show
    bench-report

    # dependent on streamly-process, streamly-coreutils, packdiff
    relcheck

    markdown-doctest
    # haskell-perf
    # streamly-lz4
  ];

  in hackage-packages
    ++ pre-release-packages
    ++ [] # Add any other packages here
    ;
}
