{pkgs, hpkgs, vim, vscodium}:
{ packages =
    [ # Editors
      vim
      pkgs.par                     # paragraph formatting for vim
      pkgs.powerline-fonts         # for vim status line
      vscodium

      # nixpkgs.pkgs
      pkgs.cabal-install
      #pkgs.hlint
      #pkgs.ghcid

      # nixpkgs.haskellPackages
      #hpkgs.fourmolu
      hpkgs.haskell-language-server
    ];
}
