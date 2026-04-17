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
  # configure them with different options. For overriding the nixpkgs-set.
  # Try --revision in cabal2nix flags
  hackage-overlay = {
    bench-show =
      hackage "0.3.2" "sha256-QCn/uyhQy/4ukxNR3rt9HG2vJXer4kkGXGWl277faJk="
      // { c2nix = ["--flag no-charts"];
           flags = ["--flags no-charts"];
           rev = "2";
           cabalSha256 = "0cr695fg7cppfv84ji5dgz591ha757882xxyyr72q59cjcy5cllf";
         };

    fusion-plugin        = hackage "0.2.8"  "05fqz1bi5zfdbjw63kcfqxfiaswm7hl98j73rx3vcxhbw06kl16b";
    streamly = hackage "0.11.0" "sha256-JMZAwJHqmDxN/CCDFhfuv77xmAx1JVhvYFDxMKyQoGk="
      // { rev = "2";
           cabalSha256 = "0b7yp4ha7h2zgjhm36allq8s0a67mbk73ckx2al5d7vn1qcdm236";
      };
    #streamly-bytestring  = hackage "0.2.3"  "sha256-ZBV7RO6ibwNKA8S/zr2r31YTQYk4vrP5d7dieTC71hY=";
    streaming-benchmarks = hackage "0.4.1"  "0q6bkj8lxhrj1q618ia5gybnknbgz86mh20rycp2m86q76c7jy78";
    streamly-core = hackage "0.3.0"  "sha256-IOrPT45LfuzU1zs4YXAsrVXYAauIKUwElgB8O7ZMk6Q="
      // { rev = "1";
           cabalSha256 = "1hjdwsc0yk4z5lhvaxnv5yw70qlpccfrbm2s4di53fz4g5r80xh0";
      };
    streamly-examples    = hackage "0.3.1"  "1wyfv35b48yhwrvsbh0ffrcjkwk61ysgr82fbsxlfldh1c3iyqrd";
    streamly-filepath    = hackage "0.1.0"  "sha256-6bXya2KhvKtn2nBFiT+XsBrQuBKRsFKkYeZUAmsQleE=";
    streamly-fsevents    = hackage "0.1.1"  "0caln42s7s87f41drncaicp7924rkkbc1qwdykgcl6d1m9g8xw4i";
    # XXX Needs to be fixed for newer streamly versions
    #streamly-lz4         = hackage "0.1.2"  "sha256-zQ0cgMtp6+psBhN0S5Pszm9Uzy2rRUFN95A+EM/xWHY=";
    streamly-process     = hackage "0.4.1"  "0sz8bqrhkw58qcsmgl53lbna6ifxcj8nz7xwdvfwy1mqdn58094v";
    streamly-statistics  = hackage "0.2.0"  "sha256-mkr7a3UOCFQqCQl+FRUruPaX4LZtuQt32MW86emnCG4=";
    # XXX Need to update bounds on hackage
    streamly-text        = hackage "0.1.1"  "0lfwyxfb0i2yp0vb6js2shvzgxcbqlmx7kgshiswvv3a0yyw2jm8";

    # This can force packages like pandoc to be rebuilt.
    #unicode-data         = hackageProf "0.6.0" "sha256-gW1E5VFwZcUX5v1dvi3INDDqUuwCcOTjCR5+lOW3Obc==";
    };

    # Latest github versions of the released packages, for overriding the
    # hackage-overlay.
    github-overlay = {
      bench-show           = cwgh "bench-show" "181480a2ce33a0d32bed1bc6a18e6063b02ae54e"
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
    pre-release-set = {
      bench-report         = cwgh "bench-report"
                               "78e127ef0336e8b27747e2880976714c2d29aa4a"
                             // { c2nix = ["--flag no-charts"];
                                  flags = ["--flags no-charts"];
                                };

      # XXX needs to be fixed for newer streamly
      #haskell-perf         = cwgh "haskell-perf"
      #                         "c9b1357f7bbd7e3e71d30ed66a90beaa5e19ec36";

      markdown-doctest     = cwgh "markdown-doctest"
                               "05dcf5f03128c49b66cf7c7778f567da1990014c";

      packdiff             = cwgh "packdiff"
                               "99c2925cd24a32115584dc5d521581b1d0767071";

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

#layers = [ nixpkgs-set hackage-overlay github-overlay pre-release-set ];
layers = [ nixpkgs-set hackage-overlay pre-release-set ];

jailbreaks = [];
}
