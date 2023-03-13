# Streamly Dev Shell

Nix shell based development environment for Haskell Streamly
ecosystem. Includes the following:

* Haskell compiler - `ghc`
* Haskell project build tool - `cabal`
* Streamly ecosystem libraries
* Hoogle server for documentation
* Haskell language server (HLS)
* A few other Haskell dev tools
* Vi editor `nvim`
* Visual Studio Code editor `codium`

Check the `nixpkgs` version in [default.nix](default.nix).

Please refer to
[this page](https://haskell-language-server.readthedocs.io/en/latest/features.html)
for Haskell language server features.

# How to use the Shell?

To get a shell with the development environment installed in it, use the
following command:

```
$ nix-shell https://github.com/composewell/streamly-packages/archive/v0.1.0.tar.gz
```

By default everything is installed. If it takes too long or uses too
much disk space, you can pass arguments to the nix expression to
customize install, for example:

```
$ nix-shell --arg haskell-tools false --arg hoogle false ...
```

Check out [default.nix](default.nix) for all available options.

Once you are in the shell, you can use `ghc`, `cabal`, `nvim`, `codium`,
`hoogle`, and other tools from the PATH. `ghc` will have streamly packages
installed in its package database, so you can directly use it without any
package downloads.

Note: To run the nix-shell, you can also clone the streamly-packages
repo and run `nix-shell` from the repo root directory.

# Updating package versions

To update the versions of Haskell packages included, edit the
[nix/haskellPackages.nix](nix/haskellPackages.nix) file to specify
particular git commit ids or package versions from hackage to be used.

Changing a package version may break other packages dependent on the changed
package. If you do not need the broken packages you can comment those in
[default.nix](default.nix). Otherwise change the versions of the broken
packages as well accordingly.

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

If you have started the nix-shell with `haskell-tools` included, you
will have the Haskell Language Server installed in the shell.  If you
get a pop up saying: "How do you want the extension to manage/discover
HLS and the relevant toolchain?" just choose, "Manually via PATH".

You can also set it later in the following section in settings:
  * Extensions
    * Haskell
      * Manage HLS
        * PATH

If you wish to use your existing installation of VSCode instead of
`codium` from the nix-shell, you can do that too, just make sure to run
it from within the nix-shell so that it is able to use the installed
Haskell tools and libraries. For example, on MacOS, if you have your
vscode app in `Downloads` folder:

```
$ open ~/Downloads/Visual\ Studio\ Code.app
```
