# Copyright   : (c) 2022 Composewell Technologies
# For faster build using less space we disable profiling
# XXX pass profiling as an option
{ nixpkgs, system }:
let
  withHaddock = true;

  cocoa = if builtins.match ".*darwin.*" system != null then
    [ nixpkgs.darwin.apple_sdk.frameworks.Cocoa ]
  else
    [ ];

  disableProfiling = pkg:
    nixpkgs.haskell.lib.overrideCabal pkg
    (old: { enableLibraryProfiling = false; });

  hackageWith = super: pkg: ver: sha256: prof:
    nixpkgs.haskell.lib.overrideCabal
      (super.callHackageDirect
        { pkg = pkg;
          ver = ver;
          sha256 = sha256;
        } {})
      (old:
        { enableLibraryProfiling = prof;
          doHaddock = withHaddock;
          doCheck = false;
        });

  deriveHackageProf = super: pkg: ver: sha256:
    hackageWith super pkg ver sha256 true;

  deriveHackage = super: pkg: ver: sha256:
    hackageWith super pkg ver sha256 false;

  # we can possibly avoid adding our package to HaskellPackages like
  # in the case of nix-shell for a single package?
  local = super: pkg: path: opts: inShell:
    let orig = super.callCabal2nixWithOptions pkg path opts { };
    in if inShell
    # Avoid copying the source directory to nix store by using
    # src = null.
    then
      orig.overrideAttrs (oldAttrs: { src = null; })
    else
      orig;

  deriveGit = super: pkg: url: rev: branch: subdir: flags: prof:
    nixpkgs.haskell.lib.overrideCabal (let
      src = fetchGit {
        url = url;
        rev = rev;
        ref = branch;
      };
    in super.callCabal2nix pkg "${src}${subdir}" { }) (old: {
      librarySystemDepends = cocoa;
      enableLibraryProfiling = prof;
      doHaddock = withHaddock;
      doCheck = false;
      configureFlags = flags;
    });

  deriveGithub = super: pkg: rev: branch: subdir: flags:
    deriveGit super pkg "git@github.com:${pkg}.git" rev branch subdir flags false;

  makeOverrides = super: sources:
    builtins.mapAttrs (name: spec:
      if spec.type == "hackage" then
        if spec.profiling == true then
          deriveHackageProf super name spec.version spec.sha256
        else deriveHackage super name spec.version spec.sha256
      else if spec.type == "github" then
        deriveGithub super "${spec.owner}/${spec.repo}" spec.rev spec.branch spec.subdir spec.flags
      else
        throw "Unknown package source type: ${spec.type}"
    ) sources;

in
{
  #inherit disableProfiling;
  inherit cocoa;
  inherit makeOverrides;
}
