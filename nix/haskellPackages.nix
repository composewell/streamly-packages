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
                          ver = "0.2.6";
                          sha256 = "sha256-Hub0nrv+kq/dK2QDSFC7yo4PMRLwKLpofmzgJjmtCLo=";
                        } {};

                    #streamly-core = utils.githubSubdir super
                    #    "composewell/streamly"
                    #    "c6bc31792089bd31c74aebea51b5038c24a81e5a"
                    #    "/core";

                    streamly-core =
                      super.callHackageDirect
                        { pkg = "streamly-core";
                          ver = "0.1.0";
                          sha256 = "sha256-hoSV6Q2+X5a7hFnJAArqNPjcMaCVyX9Vz4FcxeJ+jgI=";
                        } {};

                    #streamly = utils.github super
                    #    "composewell/streamly"
                    #    "c6bc31792089bd31c74aebea51b5038c24a81e5a";

                    streamly =
                      super.callHackageDirect
                        { pkg = "streamly";
                          ver = "0.9.0";
                          sha256 = "sha256-eOxVb8qQjZDo1+S7CStqYSExOg2QHWkMY+zlOYqwZak=";
                        } {};

                    streamly-bytestring = utils.github super
                        "psibi/streamly-bytestring"
                        "66f3ada3b8a8b760b4e32065206b557428fcef6c";

                    streamly-coreutils = utils.github super
                        "composewell/streamly-coreutils"
                        "d36e0810b9f091eafaadc183a02de9c0cce6eada";

                    #streamly-examples = utils.github super
                    #    "composewell/streamly-examples"
                    #    "b6f55d229f9e3dee6cd4f1148cc1d52949fd15f8";

                    streamly-examples =
                      super.callHackageDirect
                        { pkg = "streamly-examples";
                          ver = "0.1.3";
                          sha256 = "sha256-clZw1bNS66X4jOWKIqAMTXpIvJgvRhs5yCBWsHqZTIs=";
                        } {};

                    streamly-lz4 = utils.github super
                        "composewell/streamly-lz4"
                        "6ce34e21275f16786f1541419554ea3a9540747a";

                    streamly-metrics = utils.github super
                        "composewell/streamly-metrics"
                        "d59127df9aaf3298c743c562470bf99dacbdb6b8";

                    streamly-process = utils.github super
                        "composewell/streamly-process"
                        "d80b860d9d8ea98e4f7f63390442b3155c34dd08";

                    streamly-shell = utils.github super
                        "composewell/streamly-shell"
                        "b0c6318119d1cc5e2106343f17b5cff2ad94417f";

                    streamly-statistics = utils.github super
                        "composewell/streamly-statistics"
                        "a8f1621a93149127f98d02ec14444103c4ea338d";

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
