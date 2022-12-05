# Streamly Development Shell

Nix shell based development environment for Haskell Streamly
ecosystem. Includes the following:

* Haskell compiler `ghc`
* Haskell project build tool `cabal`
* Streamly ecosystem libraries
* Hoogle server for documentation
* Haskell language server (HLS)
* A few other Haskell dev tools
* Vi editor `nvim`
* Visual Studio Code editor `code`

Check the `nixpkgs` version in `default.nix`.

See https://haskell-language-server.readthedocs.io/en/latest/features.html for
Haskell language server features.

# How to use it?

Run nix-shell, and use ghc, cabal from the PATH:

```
$ nix-shell https://github.com/composewell/streamly-packages/archive/v0.1.0.tar.gz
```

You can also clone the repo and run `nix-shell` from the repo root directory.

By default everything is installed. If it takes too long or uses too
much disk space, you can pass some arguments to nix-shell to customize
install, for example:

```
$ nix-shell --arg haskell-tools false --arg hoogle false ...
```

# Accessing the documentation

Inside the nix shell, run the following command:

```
$ hoogle server --local -p 8080
```

Open the URL `http://127.0.0.1:8080` in your browser.

# Using vim editor

Inside the nix shell, run the following command:

```
$ nvim
```

Use `ESC :q` to quit.
Use `,h` for help.
Use `:colorscheme morning` if you want a light theme.

Add the following to your `$HOME/.config/nvim/coc-settings.json` to use the
haskell language server with nvim:

```
{
  "languageserver": {
    "haskell": {
      "command": "haskell-language-server-wrapper",
      "args": ["--lsp"],
      "rootPatterns": ["*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml"],
      "filetypes": ["haskell", "lhaskell"],
      "settings": {
        "haskell": {
          "checkParents": "CheckOnSave",
          "checkProject": true,
          "formattingProvider": "fourmolu"
        }
      }
    }
  }
}
```

# Using VSCode editor

To run VSCodium, the open source version of Microsoft VSCode, run the
following command in the nix-shell:

```
$ codium
```

If you get a pop up saying: "How do you want the extension to
manage/discover HLS and the relevant toolchain?" Choose, "Manually
via PATH" if you have built the nix derivation with `haskell-tools`
included. You can also set it in the following section in settings:
  * Extensions
    * Haskell
      * Manage HLS
        * PATH

You can also use your existing installation of VSCode, just make sure to
run it from the nix-shell so that the language server is able to see the
installed libraries.
