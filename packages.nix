{nixpkgs}:
let
  pkgs = nixpkgs.pkgs;
  hpkgs = nixpkgs.haskellPackages;
  src =
      builtins.fetchTarball {
        url = "https://github.com/composewell/nixpack-editors/archive/c06b997ca7f1c1f2116557a330e0ed0e9b042cb1.tar.gz";
        sha256 = "sha256:12gj4knx687sdbc1qwpvwgc6swab6y8nzabi083zjrgmb2dry519";
      };
  editors = import "${src}/nix" {inherit nixpkgs;};
in
{
packages =
    [ # Editors
      editors.nvimWithConfig
      editors.vim_bashrc
      editors.vim_gitconfig
      editors.vscodiumWithConfig

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
    #++ composewell-packages
    ++ [] # Add any other packages here
    ;
}
