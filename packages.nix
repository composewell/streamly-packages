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
      hpkgs.nixpack-editors.vscodiumWithConfig

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

let streamly-packages = [
    fusion-plugin
    streamly-core
    streamly

    # dependent on streamly
    streamly-bytestring
    streamly-text
    streamly-filepath

    streamly-fsevents
    streamly-examples
    streamly-process
    streamly-coreutils
    streamly-statistics
  ];

  composewell-packages = [
    # dependent on streamly-process
    simple-rpc
    simple-rpc-generate

    packdiff

    bench-show
    # depends on streamly-coreutils, bench-show
    bench-report

    # depends on bench-report, on macOS fails with heap-overflow
    # streaming-benchmarks

    # dependent on streamly-process, streamly-coreutils, packdiff
    relcheck

    markdown-doctest
    # haskell-perf
    # streamly-lz4
  ];

  in streamly-packages
    ++ composewell-packages
    ++ [] # Add any other packages here
    ;
}
