# Copyright   : (c) 2022 Composewell Technologies

{nixpkgs, compiler}:
let
    utils = (import ./utils.nix) { inherit nixpkgs; };

    haskellPackages =
        if compiler == "default"
        then nixpkgs.haskellPackages
        else nixpkgs.haskell.packages.${compiler};

    recompile = pkg:
        pkg.overrideAttrs (oldAttrs:
          { doCheck = false;
            #doHaddock = false;
            configureFlags =
              oldAttrs.configureFlags ++ ["--disable-tests"];
          });

    overriddenHaskellPackages =
        haskellPackages.override {
            overrides = self: super:
                with nixpkgs.haskell.lib;
                {
                    # stan fails to build on macOS x86_64
                    #haskell-language-server =
                    #if nixpkgs.lib.strings.hasInfix "darwin" builtins.currentSystem
                    #then
                    #  super.haskell-language-server.overrideAttrs (old: {
                    #    configureFlags = (old.configureFlags or []) ++ [ "-f -stan" ];
                    #    buildInputs = builtins.filter (pkg: pkg.pname or "" != "stan") (old.buildInputs or []);
                    #    propagatedBuildInputs = builtins.filter (pkg: pkg.pname or "" != "stan") (old.propagatedBuildInputs or []);
                    #  })
                    #else super.haskell-language-server;

                    # Streamly ecosystem packages
                    fusion-plugin = utils.hackage super
                      "fusion-plugin" "0.2.7"
                      "sha256-+TuzCAzpTUrlXwldOiHi5ZL92ui7rTVb33iqF7o8xAI=";

                    #streamly = utils.github super
                    #    "composewell/streamly"
                    #    "c6bc31792089bd31c74aebea51b5038c24a81e5a";

                    #streamly =
                    #  nixpkgs.haskell.lib.overrideCabal
                    #      (
                    #        super.callHackageDirect
                    #          { pkg = "streamly";
                    #            ver = "0.9.0";
                    #            sha256 = "sha256-eOxVb8qQjZDo1+S7CStqYSExOg2QHWkMY+zlOYqwZak=";
                    #          } {}
                    #      )
                    #      (old:
                    #        { librarySystemDepends =
                    #            if nixpkgs.lib.strings.hasInfix "darwin" builtins.currentSystem
                    #            then [nixpkgs.darwin.apple_sdk.frameworks.Cocoa]
                    #            else [];
                    #        });

                    streamly = utils.hackage super
                      "streamly" "0.11.0"
                      "sha256-JMZAwJHqmDxN/CCDFhfuv77xmAx1JVhvYFDxMKyQoGk=";

                    #streamly-bytestring = utils.github super
                    #    "psibi/streamly-bytestring"
                    #    "66f3ada3b8a8b760b4e32065206b557428fcef6c";

                    streamly-bytestring = utils.hackage super
                      "streamly-bytestring" "0.2.3"
                      "sha256-ZBV7RO6ibwNKA8S/zr2r31YTQYk4vrP5d7dieTC71hY=";

                    #streamly-core = utils.githubSubdir super
                    #    "composewell/streamly"
                    #    "c6bc31792089bd31c74aebea51b5038c24a81e5a"
                    #    "/core";

                    streamly-core = utils.hackage super
                      "streamly-core" "0.3.0"
                      "sha256-IOrPT45LfuzU1zs4YXAsrVXYAauIKUwElgB8O7ZMk6Q=";

                    streamly-coreutils = utils.github super
                        "composewell/streamly-coreutils"
                        "c42a623ca862df2355533df4dbac0e555f273f23";

                    #streamly-examples = utils.github super
                    #    "composewell/streamly-examples"
                    #    "b6f55d229f9e3dee6cd4f1148cc1d52949fd15f8";

                    streamly-examples = utils.hackage super
                      "streamly-examples" "0.3.0"
                      "sha256-XQ0cgMtp6+psBhN0S5Pszm9Uzy2rRUFN95A+EM/xWHY=";

                    #streamly-metrics = utils.github super
                    #    "composewell/streamly-metrics"
                    #    "d59127df9aaf3298c743c562470bf99dacbdb6b8";

                    #streamly-filepath = utils.github super
                    #    "composewell/streamly-filepath"
                    #    "94c44438667fc41b082445c809b1c3a64bd043e0";

                    streamly-filepath = utils.hackage super
                      "streamly-filepath" "0.1.0"
                      "sha256-6bXya2KhvKtn2nBFiT+XsBrQuBKRsFKkYeZUAmsQleE=";

                    #streamly-fsevents = utils.github super
                    #    "composewell/streamly-fsevents"
                    #    "fe2584e9502186090b1aee2671cca4bc14d7ad31";

                    streamly-fsevents = utils.hackage super
                      "streamly-fsevents" "0.1.0"
                      "sha256-dMdbB+CquSiUuFBdnHl2iqtaUmnB5gnKA/8xTG8NEjc=";

                    #streamly-lz4 = utils.github super
                    #    "composewell/streamly-lz4"
                    #    "6ce34e21275f16786f1541419554ea3a9540747a";

                    #streamly-process = utils.github super
                    #    "composewell/streamly-process"
                    #    "d80b860d9d8ea98e4f7f63390442b3155c34dd08";

                    streamly-process = utils.hackage super
                      "streamly-process" "0.4.0"
                      "sha256-8E2FLdBDDpX8TwJI/1OC9KLSAq77oHJC2yMwZFz7n6U=";

                    #streamly-statistics = utils.github super
                    #    "composewell/streamly-statistics"
                    #    "909e12df169d77215a8d69fd6901f4a61a61ba3f";

                    streamly-statistics = utils.hackage super
                      "streamly-statistics" "0.2.0"
                      "sha256-mkr7a3UOCFQqCQl+FRUruPaX4LZtuQt32MW86emnCG4=";

                    streamly-text = utils.hackage super
                      "streamly-text" "0.1.0"
                      "sha256-p1gqMDVlqV1PheTzxc2qnh9RanGJLbt3IC4xnwFTlOg=";

                    # Non-streamly packages
                    #lockfree-queue =
                    #  super.callHackageDirect
                    #    { pkg = "lockfree-queue";
                    #      ver = "0.2.4";
                    #      sha256 = "sha256-h1s/tiBq5Gzl8FtenQacmxJp7zPJPnmZXtKDPvxTSa4=";
                    #    } {};

                    #size-based =
                    #  super.callHackageDirect
                    #    { pkg = "size-based";
                    #      ver = "0.1.3.0";
                    #      sha256 = "sha256-eTGKg87Ii8ySZzL2kbMjkCrUTZm4CFpvU67MkjfMesk=";
                    #    } {};

                    # test fails
                    #http2 = recompile super.http2 ;
                    # test listens on some port
                    #streaming-commons = recompile super.streaming-commons ;
                    # test listens on some port
                    #http-client = recompile super.http-client;
                    # tests take too much time
                    #ListLike = recompile super.ListLike;
                };
        };
in overriddenHaskellPackages
