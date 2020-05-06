{ pkgs, ... }: {
  enable = true;
  font = {
    name = "Fira Code Light";
    package = pkgs.fira-code;
  };
  settings = {
    bold_font = "Fira Code Regular";
    font_size = 11;
    enable_audio_bell = "no";

    foreground = "#839496";
    background = "#002b36";
    selection_foreground = "#93a1a1";
    selection_background = "#073642";

    remember_window_size = "no";
    initial_window_width = 530;
    initial_window_height = 320;

    # black
    color0 = "#073642";
    color8 = "#002b36";

    # red
    color1 = "#dc322f";
    color9 = "#cb4b16";

    # green
    color2 = "#859900";
    color10 = "#586e75";

    # yellow
    color3 = "#b58900";
    color11 = "#657b83";

    # blue
    color4 = "#268bd2";
    color12 = "#839496";

    # magenta
    color5 = "#d33682";
    color13 = "#6c71c4";

    # cyan
    color6 = "#2aa198";
    color14 = "#93a1a1";

    # white
    color7 = "#839496";
    color15 = "#fdf6e3";
  };
}
