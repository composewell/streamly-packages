# Copyright   : (c) 2022 Composewell Technologies
# License     : All rights reserved.

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
                        "3a21b44607fd710647adaa14a75d7dfd71081336"
                        "/core";

                    streamly = utils.github super
                        "composewell/streamly"
                        "3a21b44607fd710647adaa14a75d7dfd71081336";

                    streamly-coreutils = utils.github super
                        "composewell/streamly-coreutils"
                        "5498ac9e6cdf3fe11d29c3574b758616ba5797a5";

                    streamly-examples = utils.github super
                        "composewell/streamly-examples"
                        "a1703a47d2f99d850c485eb537abbbcd7c9638a8";

                    streamly-lz4 = utils.github super
                        "composewell/streamly-lz4"
                        "a929c20fb582da95783f84a48dc174204cb8601d";

                    streamly-metrics = utils.github super
                        "composewell/streamly-metrics"
                        "1a7409bd06a417457d2650c2a06b11aa4212cdf5";

                    streamly-process = utils.github super
                        "composewell/streamly-process"
                        "3ba7fd059f7fea64e8faf50dbcdb63ba82bcc018";

                    streamly-shell = utils.github super
                        "composewell/streamly-shell"
                        "5f11858e89fed9f0fdae1115a38805e7d900b483";

                    streamly-statistics = utils.github super
                        "composewell/streamly-statistics"
                        "01b6c6f631b1200b6adb66c484d1abe3dc94a3ca";

                    # Non-streamly packages
                    lockfree-queue =
                      super.callHackageDirect
                        { pkg = "lockfree-queue";
                          ver = "0.2.4";
                          sha256 = "sha256-h1s/tiBq5Gzl8FtenQacmxJp7zPJPnmZXtKDPvxTSa4=";
                        } {};

                    size-based =
                      super.callHackageDirect
                        { pkg = "size-based";
                          ver = "0.1.3.0";
                          sha256 = "sha256-eTGKg87Ii8ySZzL2kbMjkCrUTZm4CFpvU67MkjfMesk=";
                        } {};

                    # test fails
                    http2 = recompile super.http2 ;
                    # test listens on some port
                    #streaming-commons = recompile super.streaming-commons ;
                    # test listens on some port
                    #http-client = recompile super.http-client;
                    # tests take too much time
                    #ListLike = recompile super.ListLike;
                };
        };
in overriddenHaskellPackages
