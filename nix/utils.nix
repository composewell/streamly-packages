# Copyright   : (c) 2022 Composewell Technologies

{nixpkgs}:
let
    hackage = super: pkg: ver: sha256:
      nixpkgs.haskell.lib.overrideCabal
        (super.callHackageDirect
          { pkg = pkg;
            ver = ver;
            sha256 = sha256;
          } {})
        (old:
          { #enableLibraryProfiling = prof;
            #doHaddock = false;
            doCheck = false;
          });

    # we can possibly avoid adding our package to HaskellPackages like
    # in the case of nix-shell for a single package?
    local = super: pkg: path: opts: inShell:
                let orig = super.callCabal2nixWithOptions pkg path opts {};
                 in if inShell
                    # Avoid copying the source directory to nix store by using
                    # src = null.
                    then orig.overrideAttrs (oldAttrs: { src = null; })
                    else orig;

    gitBranchDirFlags =
      super: pkg: url: rev: branch: subdir: flags:
        nixpkgs.haskell.lib.overrideCabal
            (let src = fetchGit {
                url = url;
                rev = rev;
                ref = branch;
            }; in super.callCabal2nix pkg "${src}${subdir}" {})
            (old:
              { librarySystemDepends =
                  if builtins.currentSystem == "x86_64-darwin"
                  then [nixpkgs.darwin.apple_sdk.frameworks.Cocoa]
                  else [];
                #enableLibraryProfiling = false;
                #doHaddock = false;
                doCheck = false;
                configureFlags = flags;
              });

    gitSubdirFlags = super: pkg: url: rev: subdir: flags:
      gitBranchDirFlags super pkg url rev "master" subdir flags;

    gitSubdir = super: pkg: url: rev: subdir:
      gitSubdirFlags super pkg url rev subdir [];

    git = super: pkg: url: rev: gitSubdir super pkg url rev "";

    githubSubdir = super: pkg: rev: subdir:
      gitSubdir super pkg "https://github.com/${pkg}.git" rev subdir;

    github = super: pkg: rev:
      git super pkg "https://github.com/${pkg}.git" rev;

    mkShell = shellDrv: pkgs: otherPkgs: doHoogle: doBench: shellDrv.shellFor {
        packages = pkgs;
        # some dependencies of hoogle fail to build with quickcheck-2.14
        # We should use hoogle as external tool instead of building it here
        withHoogle = doHoogle;
        doBenchmark = doBench;
        # XXX On macOS cabal2nix does not seem to generate a dependency on
        # Cocoa framework.
        buildInputs =
            otherPkgs ++
            (if builtins.currentSystem == "x86_64-darwin"
            then [nixpkgs.darwin.apple_sdk.frameworks.Cocoa]
            else []);
        # Use a better prompt
        shellHook = ''
          #CFG_DIR="$HOME/.config/streamly-packages"
          #CFG_FILE="$CFG_DIR/config.empty"
          #mkdir -p "$CFG_DIR"
          #export CABAL_DIR="$CFG_DIR"
          export CABAL_CONFIG=/dev/null
          #This is commented for hls to work with VSCode
          #cabal user-config update -a "jobs: 1"
          export PS1="$PS1(haskell) "
        '';
    };

in
{
    inherit hackage;
    inherit local;
    inherit gitBranchDirFlags;
    inherit gitSubdirFlags;
    inherit gitSubdir;
    inherit git;
    inherit githubSubdir;
    inherit github;
    inherit mkShell;
}
