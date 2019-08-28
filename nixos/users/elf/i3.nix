with import <nixpkgs> {};
let
  borderColor = "#002b36";
in
{
  enable = true;
  config = {
    focus.newWindow = "none";
    fonts = [ "FiraCode 8" ];
    window.hideEdgeBorders = "both";
    keybindings = lib.mkOptionDefault {
      /* Spawn terminals */
      "Mod1+Return" = "exec ${pkgs.kitty}/bin/kitty";
      "Mod1+Shift+Return" = "exec ${pkgs.kitty}/bin/kitty --class term-float";

      /* Commands missing from the default */
      "Mod1+a" = "focus parent";
      "Mod1+e" = "layout toggle split";

      /* Vim Mode */
      "Mod1+c" = "split h";

      "Mod1+h" = "focus left";
      "Mod1+Shift+h" = "move left";

      "Mod1+j" = "focus down";
      "Mod1+Shift+j" = "move down";

      "Mod1+k" = "focus up";
      "Mod1+Shift+k" = "move up";

      "Mod1+l" = "focus right";
      "Mod1+Shift+l" = "move right";

      /* Manage bars */
      "Mod1+m" = "bar mode toggle";

      "Mod1+d" = "exec \"${pkgs.rofi}/bin/rofi -sidebar-mode -show drun -modi window,drun,ssh,run\"";
    };
    colors.focused = {
      background = "#285577";
      border = "#4c7899";
      childBorder = borderColor;
      indicator = "#2e9ef4";
      text = "#ffffff";
    };
    colors.unfocused = {
      background = "#222222";
      border = "#333333";
      childBorder = borderColor;
      indicator = "#292d2e";
      text = "#888888";
    };
    colors.focusedInactive = {
      background = "#5f676a";
      border = "#333333";
      childBorder = borderColor;
      indicator = "#484e50";
      text = "#ffffff";
    };
    colors.placeholder = {
      background = "#0c0c0c";
      border = "#000000";
      childBorder = borderColor;
      indicator = "#000000";
      text = "#ffffff";
    };
    bars = [
      {
        trayOutput = "none";
      }
    ];
  };
  extraConfig = ''
    default_border none

    for_window [class="term-float"] border pixel 30, floating enable
    for_window [title="term-float"] border pixel 30, floating enable
  '';
}
