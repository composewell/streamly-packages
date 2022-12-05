# Copyright (c) 2022 Composewell Technologies

{nixpkgs}:
with import ../utils.nix {nixpkgs = nixpkgs;};
let plugins = with nixpkgs.pkgs.vimPlugins; {
        # plugins always loaded on start
        start =
        [ # Async build
          neomake

          # Appearance
          vim-airline
          vim-colors-solarized
          wombat256
          vim-indent-guides

          # Navigation
          nerdtree
          vim-easymotion
          vim-indentwise
          vim-indent-object

          # Finder (file, buffer, mru, tag)
          ctrlp

          # Editing
          vim-mundo
          align
          tabular
          vim-commentary

          # Completion/Language server
          #supertab
          coc-nvim

          # tmux
          vim-tmux-navigator
          tslime # https://github.com/jgdavey/tslime.vim
          vim-tbone # yank and paste to/from tmux buffers

          # Git
          gitignore-vim
          vim-fugitive
          vim-extradite

          # Haskell
          haskell-vim             #, { 'for': 'haskell' }
          #vim-haskellConcealPlus  #, { 'for': 'haskell' }
          vim-hoogle              #, { 'for': 'haskell' }
          hlint-refactor-vim      #, { 'for': 'haskell' }

          # Nix
          vim-addon-nix

          #vim-bracketed-paste
          #vimproc-vim
          #InstantRst
          #vim-instant-markdown' # , { 'for': 'markdown'} " markdown WYSIWYG in browser
          #diffchar causes random characters displayed very often - blacklisted
          #diffchar.vim

        ];
        # Optional plugins: can be added using `:packadd $plugin-name`
        # To automatically load a plugin when opening a filetype, add
        # vimrc lines like: autocmd FileType php :packadd phpCompletion
        opt = [
            # YouCompleteMe causes download of more than 500 MB, taking more
            # than 2GB space on disk.
            # Slows startup, so we load it on insert
            # YouCompleteMe #, { 'on': [] }
            delimitMate

            ultisnips
            vim-snippets # Snippets repository

            # Web Development
            tern_for_vim        # { 'for': 'javascript'} JS completions
            vim-jsbeautify      # { 'for': 'javascript'}
            vim-javascript      # { 'for': 'javascript'}
            purescript-vim      # { 'for': 'purescript'}

            python-mode # { 'for': 'python'}
            vim-scala   # { 'for': 'scala'}
        ];
    };

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
bashrc = writeShellScriptTo "bashrc_vim" "/etc/bashrc.d/01_vim"
''
alias vi='nvim'
alias vim='nvim'
alias vimdiff='nvim -d'
'';

#------------------------------------------------------------------------------
# gitconfig
#------------------------------------------------------------------------------
gitconfig =
let gitCfg =
''
# vim: ft=gitconfig

[core]
    editor = nvim

[diff]
    tool = nvimdiff

[difftool "nvimdiff"]
    cmd = "nvim -d \"$LOCAL\" \"$REMOTE\""
'';
in nixpkgs.writeTextFile {
    name = "gitconfig-vim";
    text = gitCfg;
    executable = false;
    destination = "/etc/gitconfig.vim";
};
}
