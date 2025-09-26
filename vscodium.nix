{ nixpkgs }:
{
vscodium =
  let extsCfg = import ./vscodium/extensions.nix { exts = nixpkgs.pkgs.vscode-extensions; };
   in nixpkgs.pkgs.vscode-with-extensions.override
    { vscode = nixpkgs.pkgs.vscodium;
      vscodeExtensions =
        extsCfg.extensions
        ++ nixpkgs.pkgs.vscode-utils.extensionsFromVscodeMarketplace extsCfg.marketExtensions;
    };
}
