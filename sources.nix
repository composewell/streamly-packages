{nixpack}:
# Package sources to override the nixpkgs package set.
with nixpack.mkSources;
{

# layer1 is overridden by layer2. layer1 contains packages from hackage
# only. Usually newer versions of packages that are updated on hackage
# but not yet made to nixpkgs release we are using.

layers = [

{
  #fusion-plugin        = hackage "0.2.7"  "sha256-+TuzCAzpTUrlXwldOiHi5ZL92ui7rTVb33iqF7o8xAI=";
  streamly             = hackage "0.11.0" "sha256-JMZAwJHqmDxN/CCDFhfuv77xmAx1JVhvYFDxMKyQoGk=";
  streamly-bytestring  = hackage "0.2.3"  "sha256-ZBV7RO6ibwNKA8S/zr2r31YTQYk4vrP5d7dieTC71hY=";
  streamly-core        = hackage "0.3.0"  "sha256-IOrPT45LfuzU1zs4YXAsrVXYAauIKUwElgB8O7ZMk6Q=";
  streamly-examples    = hackage "0.3.0"  "sha256-XQ0cgMtp6+psBhN0S5Pszm9Uzy2rRUFN95A+EM/xWHY=";
  streamly-filepath    = hackage "0.1.0"  "sha256-6bXya2KhvKtn2nBFiT+XsBrQuBKRsFKkYeZUAmsQleE=";
  streamly-fsevents    = hackage "0.1.0"  "sha256-dMdbB+CquSiUuFBdnHl2iqtaUmnB5gnKA/8xTG8NEjc=";
  streamly-process     = hackage "0.4.0"  "sha256-8E2FLdBDDpX8TwJI/1OC9KLSAq77oHJC2yMwZFz7n6U=";
  streamly-statistics  = hackage "0.2.0"  "sha256-mkr7a3UOCFQqCQl+FRUruPaX4LZtuQt32MW86emnCG4=";
  streamly-text        = hackage "0.1.0"  "sha256-p1gqMDVlqV1PheTzxc2qnh9RanGJLbt3IC4xnwFTlOg=";

  # This can force packages like pandoc to be rebuilt.
  #unicode-data         = hackageProf "0.6.0" "sha256-gW1E5VFwZcUX5v1dvi3INDDqUuwCcOTjCR5+lOW3Obc==";
}

# These are packages that are used to override the above packages in
# the first layer (hackage). This contains github locations of package
# versions not yet on hackage. If we comment out this layer we are left
# with packages on hackage only.

{
  bench-show           = composewellOpts "bench-show"
                           "422e88f8d96163992e849d40dcbbfdea00f61083"
                           [ "--flag no-charts" ]
                           [ "--flags no-charts" ];

  streaming-benchmarks = composewell "streaming-benchmarks"
                           "3f24dfc7943faab4c183b88815968f56c36081ec";

  streamly             = composewell "streamly"
                           "6a596733e1eb022d8b4134bd2b123cdcd4dc05e8";

  streamly-core        = composewellSubdir "streamly"
                           "6a596733e1eb022d8b4134bd2b123cdcd4dc05e8" "/core";

  streamly-fsevents    = composewell "streamly-fsevents"
                           "fe2584e9502186090b1aee2671cca4bc14d7ad31";

  streamly-text        = composewell "streamly-text"
                           "ec6dd787246fdc93c6b6f935846fe126244b552b";

  streamly-lz4         = composewell "streamly-lz4"
                           "a929c20fb582da95783f84a48dc174204cb8601d";

  # ---------------------------------------------------------------
  # Pre-release packages
  # ---------------------------------------------------------------

  bench-report         = composewellOpts "bench-report"
                           "4dad3ea916a950524bcfd5097fc6f0f63e645987"
                           [ "--flag no-charts" ]
                           [ "--flag no-charts" ];

  #haskell-perf         = composewell "haskell-perf"
  #                         "c9b1357f7bbd7e3e71d30ed66a90beaa5e19ec36";

  markdown-doctest     = composewell "markdown-doctest"
                           "05dcf5f03128c49b66cf7c7778f567da1990014c";

  packdiff             = composewell "packdiff"
                           "37bef504c07df43cb4745b1ddab5fcbfde8d310b";

  relcheck             = composewell "relcheck"
                           "cfd2b83e15d5a583876fff3eec43d01313219cde";

  simple-rpc           = composewellSubdir "simple-rpc"
                           "1559b75214e6fde7e10b20889aa1e66c12e641f0" "/rpc";

  simple-rpc-generate  = composewellSubdir "simple-rpc"
                           "1559b75214e6fde7e10b20889aa1e66c12e641f0" "/generate";

  streamly-coreutils   = composewell "streamly-coreutils"
                           "fa180060c7510c89d2767980ca6f7ec7011d04b9";

  #streamly-metrics     = composewell "streamly-metrics"
  #                         "6080649563c6764f473e1279508506f91bb20b9f";
}
];

jailbreaks = [];
}
