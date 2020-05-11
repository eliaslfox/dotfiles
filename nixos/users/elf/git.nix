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
    s = "status --short";
    mb = "checkout -b";
    tree = "!exa -l -T --git";
  };
  delta = {
    enable = true;
    options = [ "--theme=none" "--hunk-style=plain" ];
  };
  extraConfig = {
    core = {
      editor = "nvim";
      whitespace = "blank-at-eol,blank-at-eof,space-before-tab";
    };
    help = { autocorrect = 1; };
    status = {
      showStatus = true;
      submoduleSummary = true;
    };
    push = { default = "current"; };
  };
}
