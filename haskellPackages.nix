# Copyright   : (c) 2022 Composewell Technologies
# License     : All rights reserved.

{nixpkgs, compiler}:
let
    utils = (import ./utils.nix) { inherit nixpkgs; };

    haskellPackages =
        if compiler == "default"
        then nixpkgs.haskellPackages
        else nixpkgs.haskell.packages.${compiler};

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
                        "e061109f76ef37a288de0cafa37ea950c467cb82"
                        "/core";

                    streamly = utils.github super
                        "composewell/streamly"
                        "e061109f76ef37a288de0cafa37ea950c467cb82";

                    streamly-coreutils = utils.github super
                        "composewell/streamly-coreutils"
                        "acf1ca79b964e7c92ddfc71ca77c1adcba7e2450";

                    streamly-examples = utils.github super
                        "composewell/streamly-examples"
                        "be3e280883be89b94c6b7b67a5bd171bf0dbc06f";

                    streamly-lz4 = utils.github super
                        "composewell/streamly-lz4"
                        "a929c20fb582da95783f84a48dc174204cb8601d";

                    streamly-metrics = utils.github super
                        "composewell/streamly-metrics"
                        "1970d50381fc71de27f0f39cd7f3f5787373b8f9";

                    streamly-process = utils.github super
                        "composewell/streamly-process"
                        "fb45eedcd1320d552fb49048e1d733cbf5d46711";

                    streamly-shell = utils.github super
                        "composewell/streamly-shell"
                        "05200f63005970a8cbfe5b4f83a2d3a7ed42554b";

                    streamly-statistics = utils.github super
                        "composewell/streamly-statistics"
                        "0145cd27fafb07df506bbc84de5b400103639021";

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
                };
        };
in overriddenHaskellPackages
