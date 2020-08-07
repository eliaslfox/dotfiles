{ pkgs, ... }: {
  enable = true;
  userName = "Elias Lawson-Fox";
  userEmail = "me@eliaslfox.com";
  ignores = [
    # Swap Files
    "*~"
    "*.swp"

    # Clangd Metadata
    "compile_commands.json"
  ];
  signing = {
    signByDefault = true;
    key = "0x2E9DA81892721D77";
  };
  aliases = {
    l = "log --decorate --oneline --graph --first-parent";
    mb = "checkout -b";
    tree = "!exa -l -T --git";
  };
  extraConfig = {
    core = {
      editor = "nvim";
      pager = "${pkgs.gitAndTools.delta}/bin/delta --syntax-theme=none --hunk-header-style=omit";
      autocrlf = "input";
    };
    init = {
      defaultBranch = "main";
    };
    help = {
      autocorrect = 1;
    };
    status = {
      submoduleSummary = true;
      showUntrackedFiles = "all";
      showStash = true;
    };
    push = {
      default = "current";
      followTags = true;
      recurseSubmodules = "on-demand";
    };
    pull = {
      ff = "only";
    };
    commit = {
      verbose = true;
    };
    diff = {
      mnemonicPrefix = true;
      submodule = "log";
    };
    fetch = {
      prune = true;
      pruneTags = true;
    };
    log.follow = true;
    rebase.missingCommitsCheck = "error";
    tag.gpgSign = true;
    interactive.diffFilter = "${pkgs.gitAndTools.delta}/bin/delta --color-only --theme=none";
    advice = {
      addEmptyPathSpec = false;
      detachedHead = false;
    };
  };
}
