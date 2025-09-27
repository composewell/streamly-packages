# Nix Shell for Haskell Development

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

The version of `nixpkgs` can be changed in the [shell.nix](shell.nix) file.

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

If it takes too long to build the hoogle file you can disable hoogle:

```
nix-shell --arg hoogle false ...
```

Use the cloning method if you would like to customize the environment
before using. For example, if it is using too much space
installing packages that you do not need.

## By cloning the github repo

You can clone the `streamly-packages` repo and run `nix-shell`
command from the repo root directory.

```
git clone https://github.com/composewell/streamly-packages
cd streamly-packages
nix-shell
```

You can comment out any packages you do not need in
[packages.nix](packages.nix).

# Using the Shell

Once you are in the shell, you can use `ghc`, `cabal`, `nvim`, `codium`,
`hoogle`, and other CLI tools from the PATH. Essential streamly packages
are pre-installed in the `ghc` package database, ready to use.

To start with, you can try building and running the examples from the
[streamly-examples](https://github.com/composewell/streamly-examples/tree/v0.3.0/examples)
package.

Alternatively, you can start the interactive repl `ghci` and play with Haskell
code interactively.

# Show installed packages

To show the Haskell packages that are already installed in the shell,
run the following command in the nix shell:

```
ghc-pkg list
```

# Building a Haskell Package

<!--
We do not depend on cabal to download and build the dependencies.  Do
not use `cabal update` to avoid building the dependencies.  Instead add
your dependencies in [packages.nix](packages.nix), the dependencies are
pre-installed in the shell from nixpkgs.

It uses `$HOME/.config/streamly-packages` as the CABAL_DIR to avoid
building packages using cabal. If by mistake you run the `cabal update`
command then cabal may start building dependencies instead of using
from nixpkgs. If you did not intend to do that then you can remove the
hackage database index from `$HOME/.config/streamly-packages` or remove
that entire directory itself.
-->

We do not depend on cabal to download and build the dependencies.
Instead add your project dependencies in the library section of
[packages.nix](packages.nix), any package specified here and all its
dependencies are pre-installed in the shell from nixpkgs.

For example to build the streamly-examples package:
```
git clone https://github.com/composewell/streamly-examples
cd streamly-examples
cabal build
```

# Overriding package versions

To override or update the versions of Haskell packages used, edit the
[haskell-sources.nix](haskell-sources.nix) file to specify
particular git commit ids or package versions from hackage to be used.

<!--
Changing a package version may break other packages dependent on the changed
package. If you do not need the broken packages you can comment those in
[default.nix](default.nix). Otherwise change the versions of the broken
packages as well accordingly.
-->

# Adding your own packages

If you need any additional packages in this environment just add
them to the list of packages in [packages.nix](packages.nix).

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

To customize vim plugins edit the [vim/plugins.nix](vim/plugins.nix) file.

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

To customize vscode extensions edit the [vscodium/extensions.nix](vscodium/extensions.nix) file.
