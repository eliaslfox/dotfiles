{ pkgs, ... }: {
  enable = true;
  userName = "Elias Lawson-Fox";
  userEmail = "me@eliaslfox.com";
  ignores = [ "*~" "*.swp" ];
  signing = {
    signByDefault = true;
    key = "0x2E9DA81892721D77";
  };
  aliases = {
    l = "log --decorate --oneline --graph --first-parent";
    s = "status";
    c = "checkout";
    mb = "checkout -b";
  };
  extraConfig = {
    core = {
      editor = "nvim";
      whitespace = "blank-at-eol,blank-at-eof,space-before-tab";
      pager = ''
        ${pkgs.gitAndTools.delta}/bin/delta --plus-color="#012800" --minus-color="#340001" --theme=none --hunk-style=plain'';
    };
    help = { autocorrect = 1; };
    status = {
      showStatus = true;
      submoduleSummary = true;
    };
    interactive = {
      diffFilter =
        "${pkgs.gitAndTools.delta}/bin/delta --color-only --theme=none";
    };
    push = { default = "current"; };
  };
}
