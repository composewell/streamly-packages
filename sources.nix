# Package sources to override the nixpkgs package set.
# You can add packages from hackage or github.
with import ./src/sources.nix;
let
  composewell = repo: rev:
    github "composewell" repo rev;
in
{
  # Overrides from hackage
  fusion-plugin        = hackage "0.2.7"  "sha256-+TuzCAzpTUrlXwldOiHi5ZL92ui7rTVb33iqF7o8xAI=";
  streamly             = hackage "0.11.0" "sha256-JMZAwJHqmDxN/CCDFhfuv77xmAx1JVhvYFDxMKyQoGk=";
  streamly-bytestring  = hackage "0.2.3"  "sha256-ZBV7RO6ibwNKA8S/zr2r31YTQYk4vrP5d7dieTC71hY=";
  streamly-core        = hackage "0.3.0"  "sha256-IOrPT45LfuzU1zs4YXAsrVXYAauIKUwElgB8O7ZMk6Q=";
  streamly-examples    = hackage "0.3.0"  "sha256-XQ0cgMtp6+psBhN0S5Pszm9Uzy2rRUFN95A+EM/xWHY=";
  streamly-filepath    = hackage "0.1.0"  "sha256-6bXya2KhvKtn2nBFiT+XsBrQuBKRsFKkYeZUAmsQleE=";
  streamly-fsevents    = hackage "0.1.0"  "sha256-dMdbB+CquSiUuFBdnHl2iqtaUmnB5gnKA/8xTG8NEjc=";
  streamly-process     = hackage "0.4.0"  "sha256-8E2FLdBDDpX8TwJI/1OC9KLSAq77oHJC2yMwZFz7n6U=";
  streamly-statistics  = hackage "0.2.0"  "sha256-mkr7a3UOCFQqCQl+FRUruPaX4LZtuQt32MW86emnCG4=";
  streamly-text        = hackage "0.1.0"  "sha256-p1gqMDVlqV1PheTzxc2qnh9RanGJLbt3IC4xnwFTlOg=";

  # Overrides from github
  streamly-coreutils   = composewell "streamly-coreutils" "c42a623ca862df2355533df4dbac0e555f273f23";
}
