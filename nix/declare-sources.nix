let
  #--------------------------------------------------------------------------
  # Declaring packages
  #--------------------------------------------------------------------------

  hackage = version: sha256: {
    type = "hackage";
    inherit version sha256;
    profiling = false;
  };

  hackageProf = version: sha256: {
    type = "hackage";
    inherit version sha256;
    profiling = true;
  };

  githubAll = owner: repo: rev: branch: subdir: flags: {
    type = "github";
    inherit owner repo rev branch subdir flags;
  };

  master = "master";

  githubBranchFlags = owner: repo: rev: branch: flags:
    githubAll owner repo rev branch "" flags;

  githubFlags = owner: repo: rev: flags:
    githubBranchFlags owner repo rev master flags;

  githubBranch = owner: repo: rev: branch:
    githubBranchFlags owner repo rev branch [];

  githubSubdir = owner: repo: rev: subdir:
    githubAll owner repo rev master subdir [];

  github = owner: repo: rev:
    githubFlags owner repo rev [];

in
{
  inherit hackage;
  inherit hackageProf;
  inherit githubBranchFlags;
  inherit githubFlags;
  inherit githubBranch;
  inherit githubSubdir;
  inherit github;
}
