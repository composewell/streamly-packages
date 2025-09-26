{pkgs, hpkgs, vim, vscodium}:
{
packages =
    [ # Editors
      vim
      pkgs.par                     # paragraph formatting for vim
      pkgs.powerline-fonts         # for vim status line
      vscodium

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
