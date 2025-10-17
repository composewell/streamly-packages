{nixpkgs}:
let
  pkgs = nixpkgs.pkgs;
  hpkgs = nixpkgs.haskellPackages;
  src =
      builtins.fetchTarball {
        url = "https://github.com/composewell/nixpack-editors/archive/52728ddf3e9cf95429e48424f16cd4f7370d02a4.tar.gz";
        sha256 = "sha256:0i1396px5vrs43c5p71xrxcknncw62ljp25lrjwrx0klcnsz1pj7";
      };
  editors = import "${src}/nix" {inherit nixpkgs;};
in
{
packages =
    [ # Editors
      editors.nvimWithConfig
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
      #streamly-examples

      # For tests and benchmarks
      hspec
      tasty-bench
      temporary
      scientific
    ];
}
