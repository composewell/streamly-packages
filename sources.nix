{nixpack}:
# Package sources to override the nixpkgs package set.
with nixpack.mkSources;
let
  # convenience functions:
  cwgh = repo: rev: gh "composewell" repo rev;

  # Packages from nixpkgs, with additional config options or to enforce
  # particular version or fail otherwise.
  nixpkgs-set = {
    bench-show =
      fromNix //
        { version = "0.3.2";
          flags = ["--flags no-charts"];
        };
    nixpack-editors = cwgh "nixpack-editors"
        "956ec2027f101dee418060279810d76c936364b2" //
        { subdir = "nix";
          build = "import";
        };
    # fusion-plugin = fromNix // { version = "0.2.7"; };
    # XXX need update
    # streamly = fromNix // { version = "0.11.0"; };
    streamly-bytestring = fromNix //
      { version = "0.2.3";
        profiling = false;
      };
    # XXX need update
    #streamly-core = fromNix // { version = "0.3.0"; };
    # XXX need update, marked broken
    #streamly-examples = fromNix // { version = "0.3.0"; };
    # XXX need update, marked broken
    #streamly-filepath = fromNix // { version = "0.1.0"; };
    # XXX need update, marked broken
    # streamly-fsevents = fromNix // { version = "0.1.0"; };
    # XXX need update
    #streamly-process = fromNix // { version = "0.4.0"; };
    # XXX need update, marked broken
    #streamly-statistics = fromNix // { version = "0.2.0"; };
    # XXX need update, marked broken
    # streamly-text = fromNix // { version = "0.1.0"; };
    unicode-data = fromNix // { version = "0.6.0"; };
  };

  # packages from hackage that may not be in our nixpkgs set yet or we want to
  # configure them with different options.
  hackage-set = {
    #bench-show =
    #  hackage "0.3.2" "sha256-QCn/uyhQy/4ukxNR3rt9HG2vJXer4kkGXGWl277faJk="
    #  // { c2nix = ["--flag no-charts"];
    #       flags = ["--flags no-charts"];
    #       # latest revision
    #       rev = "2";
    #       cabalSha256 = "0cr695fg7cppfv84ji5dgz591ha757882xxyyr72q59cjcy5cllf";
    #     };

    #fusion-plugin        = hackage "0.2.7"  "sha256-+TuzCAzpTUrlXwldOiHi5ZL92ui7rTVb33iqF7o8xAI=";
    streamly             = hackage "0.11.0" "sha256-JMZAwJHqmDxN/CCDFhfuv77xmAx1JVhvYFDxMKyQoGk=";
    #streamly-bytestring  = hackage "0.2.3"  "sha256-ZBV7RO6ibwNKA8S/zr2r31YTQYk4vrP5d7dieTC71hY=";
    streaming-benchmarks = hackage "0.3.0"  "sha256-yQ0cgMtp6+psBhN0S5Pszm9Uzy2rRUFN95A+EM/xWHY=";
    streamly-core        = hackage "0.3.0"  "sha256-IOrPT45LfuzU1zs4YXAsrVXYAauIKUwElgB8O7ZMk6Q=";
    streamly-examples    = hackage "0.3.0"  "sha256-XQ0cgMtp6+psBhN0S5Pszm9Uzy2rRUFN95A+EM/xWHY=";
    streamly-filepath    = hackage "0.1.0"  "sha256-6bXya2KhvKtn2nBFiT+XsBrQuBKRsFKkYeZUAmsQleE=";
    streamly-fsevents    = hackage "0.1.0"  "sha256-dMdbB+CquSiUuFBdnHl2iqtaUmnB5gnKA/8xTG8NEjc=";
    # XXX Needs to be fixed for newer streamly versions
    #streamly-lz4         = hackage "0.1.2"  "sha256-zQ0cgMtp6+psBhN0S5Pszm9Uzy2rRUFN95A+EM/xWHY=";
    streamly-process     = hackage "0.4.0"  "sha256-8E2FLdBDDpX8TwJI/1OC9KLSAq77oHJC2yMwZFz7n6U=";
    streamly-statistics  = hackage "0.2.0"  "sha256-mkr7a3UOCFQqCQl+FRUruPaX4LZtuQt32MW86emnCG4=";
    # XXX Need to update bounds on hackage
    #streamly-text        = hackage "0.1.0"  "sha256-p1gqMDVlqV1PheTzxc2qnh9RanGJLbt3IC4xnwFTlOg=";

    # This can force packages like pandoc to be rebuilt.
    #unicode-data         = hackageProf "0.6.0" "sha256-gW1E5VFwZcUX5v1dvi3INDDqUuwCcOTjCR5+lOW3Obc==";
    };

    # Latest github versions of the released packages.
    github-set = {
      bench-show           = cwgh "bench-show" "422e88f8d96163992e849d40dcbbfdea00f61083"
                             // { c2nix = ["--flag no-charts"];
                                  flags = ["--flags no-charts"];
                                };

      streaming-benchmarks = cwgh "streaming-benchmarks"
                               "3f24dfc7943faab4c183b88815968f56c36081ec";

      streamly             = cwgh "streamly"
                               "6a596733e1eb022d8b4134bd2b123cdcd4dc05e8";

      streamly-core        = cwgh "streamly"
                               "6a596733e1eb022d8b4134bd2b123cdcd4dc05e8"
                             // { subdir = "core"; };

      streamly-fsevents    = cwgh "streamly-fsevents"
                               "fe2584e9502186090b1aee2671cca4bc14d7ad31";

      streamly-text        = cwgh "streamly-text"
                               "ec6dd787246fdc93c6b6f935846fe126244b552b";

      streamly-lz4         = cwgh "streamly-lz4"
                               "a929c20fb582da95783f84a48dc174204cb8601d";
      };

    # Packages that are not yet on hackage, only on github.
    pre-release = {
      bench-report         = cwgh "bench-report"
                               "4dad3ea916a950524bcfd5097fc6f0f63e645987"
                             // { c2nix = ["--flag no-charts"];
                                  flags = ["--flags no-charts"];
                                };

      # XXX needs to be fixed for newer streamly
      #haskell-perf         = cwgh "haskell-perf"
      #                         "c9b1357f7bbd7e3e71d30ed66a90beaa5e19ec36";

      markdown-doctest     = cwgh "markdown-doctest"
                               "05dcf5f03128c49b66cf7c7778f567da1990014c";

      packdiff             = cwgh "packdiff"
                               "37bef504c07df43cb4745b1ddab5fcbfde8d310b";

      relcheck             = cwgh "relcheck"
                               "cfd2b83e15d5a583876fff3eec43d01313219cde";

      simple-rpc           = cwgh "simple-rpc"
                               "1559b75214e6fde7e10b20889aa1e66c12e641f0"
                             // { subdir = "rpc"; };

      simple-rpc-generate  = cwgh "simple-rpc"
                               "1559b75214e6fde7e10b20889aa1e66c12e641f0"
                             // { subdir = "generate"; };

      streamly-coreutils   = cwgh "streamly-coreutils"
                               "fa180060c7510c89d2767980ca6f7ec7011d04b9";

      # XXX to be merged with haskell-perf
      #streamly-metrics     = cwgh "streamly-metrics"
      #                         "6080649563c6764f473e1279508506f91bb20b9f";
    };
in
{

# Package sets coming later in the list override the earlier ones.
# The hackages set usually contains newer versions of packages
# that are uploaded on hackage but not yet made to nixpkgs release we
# are using. The github set is used to override even the latest hackage
# packages by the bleeding edge github packages. The pre-release set contains
# packages that are not yet released on hackage, only on github.

# If you want to use only packages from hackage then remove "github".
# You can add more sets in the list to override the previous ones.

layers = [ nixpkgs-set hackage-set github-set pre-release ];

jailbreaks = [];
}
