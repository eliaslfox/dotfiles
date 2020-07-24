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
      whitespace = "blank-at-eol,blank-at-eof,space-before-tab";
      pager = "${pkgs.gitAndTools.delta}/bin/delta --syntax-theme=none --hunk-header-style=omit";
    };
    help = { autocorrect = 1; };
    status = {
      showStatus = true;
      submoduleSummary = true;
    };
    push = { 
      default = "current"; 
    };
    pull = { 
      ff = "only"; 
    };
    commit = {
      verbose = true;
    };
    interactive = {
      diffFilter = "${pkgs.gitAndTools.delta}/bin/delta --color-only --theme=none";
    };
  };
}
