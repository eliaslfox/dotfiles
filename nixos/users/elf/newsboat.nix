{ pkgs, config, ... }:

{
  programs.newsboat = {
    enable = true;
    autoReload = true;
    browser = "${pkgs.firefox}/bin/firefox";
    urls = [
      { url = "https://feeds.feedburner.com/Torrentfreak?fmt=rss"; tags = []; }
      { url = "https://xkcd.com/rss.xml"; tags = ["comic"]; }
      { url = "https://what-if.xkcd.com/feed.atom"; tags = ["comic"]; }
      { url = "https://www.nytimes.com/services/xml/rss/nyt/HomePage.xml"; tags = ["news"]; }
    ];
    extraConfig = ''
      refresh-on-startup yes 
      color info default default reverse
      color listnormal_unread yellow default
      color listfocus blue default reverse bold
      color listfocus_unread blue default reverse bold
    '';
  };

  home.file.".config/newsboat/urls".text = config.home-manager.users.elf.home.file.".newsboat/urls".text;
  home.file.".config/newsboat/config".text = config.home-manager.users.elf.home.file.".newsboat/config".text;
}
