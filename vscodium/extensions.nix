{ exts }:

{
# Extensions from
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vscode/extensions/default.nix
extensions =
  with exts; [
    # Needs to be installed explicitly for haskell.haskell to work
    justusadam.language-haskell
    haskell.haskell
    # ms-vscode-remote.remote-ssh # unfree
  ];

# Extensions from vscode marketplace
marketExtensions =
        [
          #{
          #  name = "";
          #  publisher = "";
          #  version = "";
          #  sha256 = "";
          #}
        ];
}
