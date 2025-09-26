# Copyright (c) 2022 Composewell Technologies

{nixpkgs}:
with import ../utils.nix {nixpkgs = nixpkgs;};
let plugins = import ./plugins.nix { pkgs = nixpkgs.pkgs; };

    #vimCustom = nixpkgs.vim_configurable.customize {
    #  name = "vim";
    #  vimrcConfig.customRC = builtins.readFile ./vimrc;
    #  vimrcConfig.packages.myVimPackage = plugins;
    #};

    cheatsheet = nixpkgs.writeTextFile {
        name = "cheatsheet-vim";
        text = builtins.readFile ./cheatsheet.txt;
        executable = false;
        destination = "/etc/cheatsheet.txt";
    };

in {
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

bashrc = writeShellScriptTo "bashrc_vim" "/etc/bashrc.d/01_vim" (builtins.readFile ./bashrc);

#------------------------------------------------------------------------------
# gitconfig
#------------------------------------------------------------------------------

gitconfig =
  let gitCfg = builtins.readFile ./gitconfig;
  in nixpkgs.writeTextFile {
      name = "gitconfig-vim";
      text = gitCfg;
      executable = false;
      destination = "/etc/gitconfig.vim";
  };
}
