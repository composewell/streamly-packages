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
                    # Streamly ecosystem packages
                    fusion-plugin =
                      super.callHackageDirect
                        { pkg = "fusion-plugin";
                          ver = "0.2.5";
                          sha256 = "sha256-a5ZIi810Utsj0UsQZwnCaRYIJ8RWLUqppg4lYaNvOkM=";
                        } {};

                    streamly-core = utils.githubSubdir super
                        "composewell/streamly"
                        "3f82f0035a7eb787cd9c037c0115d4630a46e069"
                        "/core";

                    streamly = utils.github super
                        "composewell/streamly"
                        "3f82f0035a7eb787cd9c037c0115d4630a46e069";

                    streamly-coreutils = utils.github super
                        "composewell/streamly-coreutils"
                        "e51fe704dfd029784a6b504ac178e841e68ce02a";

                    streamly-examples = utils.github super
                        "composewell/streamly-examples"
                        "b6f55d229f9e3dee6cd4f1148cc1d52949fd15f8";

                    streamly-lz4 = utils.github super
                        "composewell/streamly-lz4"
                        "6ce34e21275f16786f1541419554ea3a9540747a";

                    streamly-metrics = utils.github super
                        "composewell/streamly-metrics"
                        "d59127df9aaf3298c743c562470bf99dacbdb6b8";

                    streamly-process = utils.github super
                        "composewell/streamly-process"
                        "49e5cc1ab30ad0fe8b69a9735c5ba26faa656a20";

                    streamly-shell = utils.github super
                        "composewell/streamly-shell"
                        "b0c6318119d1cc5e2106343f17b5cff2ad94417f";

                    streamly-statistics = utils.github super
                        "composewell/streamly-statistics"
                        "969a298dc8b75b1cbd60c126d0213bb2d0ccf2c1";

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
