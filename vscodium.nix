{ nixpkgs }:
{
vscodium =
  nixpkgs.pkgs.vscode-with-extensions.override
    { vscode = nixpkgs.pkgs.vscodium;
      vscodeExtensions =
        with nixpkgs.pkgs.vscode-extensions;
        # Extensions from
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vscode/extensions/default.nix
        [
          # Needs to be installed explicitly for haskell.haskell to work
          justusadam.language-haskell
          haskell.haskell
          #ms-vscode-remote.remote-ssh # unfree
        ]
        # Extensions from marketplace
        ++ nixpkgs.pkgs.vscode-utils.extensionsFromVscodeMarketplace
        [
          #{
          #  name = "";
          #  publisher = "";
          #  version = "";
          #  sha256 = "";
          #}
        ];
    };
}
