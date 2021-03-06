{ pkgs, lib, config }:
let
  borderColor = "#002b36";
  scripts = pkgs.callPackage ../../scripts.nix { };

  /*
   * This replaces the default dmenu_run script so that
   * the calling shell get's >>='ed away
   */
  dmenu-run = pkgs.writeScriptBin "dmenu-run" ''
    #!${pkgs.bash}/bin/sh
    set -eou pipefail

    exec $(${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu)
  '';
in
{
  enable = true;
  config = {
    focus.newWindow = "none";
    fonts = [ "FiraCode 8" ];
    window = {
      hideEdgeBorders = "both";
      commands = [{
        criteria.class = "term-float";
        command = "border pixel 30, floating enable";
      }];
    };
    keybindings = lib.mkOptionDefault {
      # Spawn terminals
      "Mod1+Return" = "exec ${pkgs.kitty}/bin/kitty";
      "Mod1+Shift+Return" = "exec ${pkgs.kitty}/bin/kitty --class term-float";

      # Commands missing from the default
      "Mod1+a" = "focus parent";
      "Mod1+e" = "layout toggle split";
  
      # Start Programs better
      "Mod1+d" = "exec ${dmenu-run}/bin/dmenu-run";
      "Mod1+p" = "exec ${pkgs.pass}/bin/passmenu";

      # Vim Mode
      "Mod1+c" = "split h";

      "Mod1+h" = "focus left";
      "Mod1+Shift+h" = "move left";

      "Mod1+j" = "focus down";
      "Mod1+Shift+j" = "move down";

      "Mod1+k" = "focus up";
      "Mod1+Shift+k" = "move up";

      "Mod1+l" = "focus right";
      "Mod1+Shift+l" = "move right";

      # Remove arrow key keybindings
      "Mod1+Left" = null;
      "Mod1+Right" = null;
      "Mod1+Up" = null;
      "Mod1+Down" = null;
      "Mod1+Shift+Left" = null;
      "Mod1+Shift+Right" = null;
      "Mod1+Shift+Up" = null;
      "Mod1+Shift+Down" = null;

      # Manage bars
      "Mod1+m" = "bar mode toggle";

      "Mod1+Shift+m" = "exec /run/wrappers/bin/physlock";
    };
    colors = {
      focused = lib.mkOptionDefault { childBorder = lib.mkForce borderColor; };
      unfocused =
        lib.mkOptionDefault { childBorder = lib.mkForce borderColor; };
      focusedInactive =
        lib.mkOptionDefault { childBorder = lib.mkForce borderColor; };
      placeholder =
        lib.mkOptionDefault { childBorder = lib.mkForce borderColor; };
    };
    bars = [
      ((
        if config.features.wireguard.enable then
          { statusCommand = "/run/wrappers/bin/elf-i3status"; }
        else
          { }
      ) // (
        if config.networking.hostName == "darling" then { trayOutput = "none"; } else { }
      ))
    ];
  };
  extraConfig = ''
    default_border none
  '';
}
