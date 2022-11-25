# What is this?

Nix shell based complete development environment for streamly ecosystem. It
includes:

* Streamly ecosystem packages and their dependencies, along with
  haddock documentation.
* Haskell compiler `ghc` 9.2.2 and the haskell language server.
* `nvim` editor with all the necessary plugins for haskell development.

The nix version used is
https://github.com/NixOS/nixpkgs/archive/refs/tags/22.05.tar.gz .

# How to use it?

Start a nix shell, and use the ghc, cabal, nvim commands for Haskell dev:

```
$ nix-shell https://github.com/composewell/streamly-packages/archive/master.tar.gz
```

You can also clone the repo and run `nix-shell` from the root of repo.

# Accessing the documentation

After starting the nix shell run the following command:

```
$ hoogle server --local -p 8080
```

And then access the URL `http://127.0.0.1:8080`.

# Using the language server with nvim

Add the following to your `$HOME/.config/nvim/coc-settings.json` to use the
haskell language server with nvim:

```
{
  "languageserver": {
    "haskell": {
      "command": "haskell-language-server-wrapper",
      "args": ["--lsp"],
      "rootPatterns": ["*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml"],
      "filetypes": ["haskell", "lhaskell"]
    }
  }
}
```
