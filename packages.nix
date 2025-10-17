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
