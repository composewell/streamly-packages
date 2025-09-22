# Haskell Development Shell

A ready-to-use Nix shell environment tailored for Haskell, having
Haskell Streamly and its ecosystem packages installed out of the
box. Easily customizable to include any package from Hackage.
**Includes:**

* Haskell compiler - `ghc`
* Haskell project build tool - `cabal`
* Streamly ecosystem libraries
* Hoogle server for documentation
* Haskell language server (HLS)
* A few other Haskell dev tools
* Vi editor `nvim`
* Visual Studio Code editor `codium`

Check the `nixpkgs` version used in the [default.nix](default.nix) file.

Please refer to
[this page](https://haskell-language-server.readthedocs.io/en/latest/features.html)
for Haskell language server features.

# Starting the Shell

There are two ways to start the nix shell.

## Directly using github URL

To get a shell with the development environment installed in it, use the
following command:

```
nix-shell https://github.com/composewell/streamly-packages/archive/v0.1.4.tar.gz
```

By default all optional features are installed. If it takes too long or
uses too much disk space, you can pass arguments to the nix expression
to customize install, for example:

```
nix-shell --arg haskell-tools false --arg hoogle false ...
```

Check out [default.nix](default.nix) for all available options.

## By cloning the github repo

You can clone the `streamly-packages` repo and run the `nix-shell`
command from the repo root directory.

```
git clone https://github.com/composewell/streamly-packages
cd streamly-packages
nix-shell
```

This is especially useful if you would like to customize the environment before
using.

# Using the Shell

Once you are in the shell, you can use `ghc`, `cabal`, `nvim`, `codium`,
`hoogle`, and other tools from the PATH. `ghc` will have streamly packages
installed in its package database, ready to use.

To start with, you can try building and running the examples from the
[streamly-examples](https://github.com/composewell/streamly-examples/tree/v0.3.0/examples)
package.

Alternatively, you can start the interactive repl `ghci` and run Haskell
code interactively.

# Show installed packages

To show the Haskell packages that are already installed in the shell,
run the following command in the nix shell:

```
ghc-pkg list
```

# Updating package versions

To update the versions of Haskell packages included, edit the
[nix/haskellPackages.nix](nix/haskellPackages.nix) file to specify
particular git commit ids or package versions from hackage to be used.

Changing a package version may break other packages dependent on the changed
package. If you do not need the broken packages you can comment those in
[default.nix](default.nix). Otherwise change the versions of the broken
packages as well accordingly.

# Adding your own packages

If you need any additional packages in this environment just add
them to the list of packages in [default.nix](default.nix).

# Accessing the documentation

Inside the nix shell, run the following command:

```
hoogle server --local -p 8080
```

Open the URL `http://127.0.0.1:8080` in your browser.

# Using vim editor

Inside the nix shell, run the following command:

```
nvim
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
codium
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
open ~/Downloads/Visual\ Studio\ Code.app
```
