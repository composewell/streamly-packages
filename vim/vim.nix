# Copyright (c) 2022 Composewell Technologies

{ nixpkgs }:

let
  # Load plugins from a separate file
  plugins = import ./plugins.nix { pkgs = nixpkgs.pkgs; };

  # Small helper: write a plain text file into /etc
  etcTextFile = name: path:
    nixpkgs.writeTextFile {
      inherit name;
      text = builtins.readFile path;
      executable = false;
      destination = "/etc/${name}";
    };

  cheatsheet = etcTextFile "cheatsheet.txt" ./cheatsheet.txt;
in {

  #------------------------------------------------------------------------------
  #  Generic vim/neovim configuration system
  #------------------------------------------------------------------------------
  #vimCustom = nixpkgs.vim_configurable.customize {
  #  name = "vim";
  #  vimrcConfig.customRC = builtins.readFile ./vimrc;
  #  vimrcConfig.packages.myVimPackage = plugins;
  #};

  #------------------------------------------------------------------------------
  #  nvim with plugins
  #------------------------------------------------------------------------------
  nvimCustom = nixpkgs.neovim.override {
    configure = {
      customRC =
           builtins.readFile ./vimrc
        + builtins.readFile ./vimrc.haskell
        + "nmap <Leader>h :vnew ${cheatsheet}/etc/cheatsheet.txt<CR>"
        + builtins.readFile ./vimrc.local
        + "let g:coc_node_path='${nixpkgs.nodejs}/bin/node'";
      packages.myVimPackage = plugins;
    };
  };

  #------------------------------------------------------------------------------
  # bashrc
  #------------------------------------------------------------------------------
  #bashrc =
  #  writeShellScriptTo
  #    "bashrc_vim" "/etc/bashrc.d/01_vim" (builtins.readFile ./bashrc);

  #------------------------------------------------------------------------------
  # gitconfig
  #------------------------------------------------------------------------------
  #gitconfig = etcTextFile "gitconfig.vim" ./gitconfig;
}
