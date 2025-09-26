{ pkgs }:

with pkgs.vimPlugins; {
  # plugins always loaded on start
  start = [
    # Async build
    neomake

    # Appearance / colorschemes
    vim-airline
    vim-colors-solarized
    gruvbox
    nord-vim
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
    coc-nvim

    # tmux
    vim-tmux-navigator
    tslime
    vim-tbone

    # Git
    gitignore-vim
    vim-fugitive
    vim-extradite

    # Haskell
    haskell-vim
    vim-hoogle
    hlint-refactor-vim

    # Nix
    vim-addon-nix
  ];

  # Optional plugins: loaded manually with :packadd
  opt = [
    delimitMate
    ultisnips
    vim-snippets

    # Web Development
    tern_for_vim
    vim-jsbeautify
    vim-javascript
    #purescript-vim

    python-mode
    #vim-scala
  ];
}
