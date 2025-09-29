{ nixpkgs }:
let
#------------------------------------------------------------------------------
# Vim editor configuration
#------------------------------------------------------------------------------

  vimCfg = import ../vim/vim.nix {nixpkgs = nixpkgs;};

#------------------------------------------------------------------------------
# VScode editor configuration
#------------------------------------------------------------------------------

  vscodiumCfg = import ../vscodium/vscodium.nix {inherit nixpkgs;};

in
{
  vim = vimCfg.nvimCustom;
  vscodium = vscodiumCfg.vscodium;
}
