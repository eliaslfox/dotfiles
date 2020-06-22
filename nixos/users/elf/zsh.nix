{ pkgs, ... }: {
  enable = true;
  enableCompletion = true;
  dotDir = ".config/zsh";
  autocd = true;
  sessionVariables = {
    # Basic config
    DEFAULT_USER = "elf";
    EDITOR = "nvim";

    # Setup XDG
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";

    # Use XDG
    GNUPGHOME = "$HOME/.config/gnupg";
    NIXOPS_STATE = "$HOME/.config/nixops/deployments.nixops";
    NPM_CONFIG_USERCONFIG = "$HOME/.config/npm/npmrc";
    STACK_ROOT = "$HOME/.local/share/stack";
    RUSTUP_HOME = "$HOME/.local/share/rustup";
    CARGO_HOME = "$HOME/.local/share/cargo";

    # Handle temp ~
    PASSWORD_STORE_DIR = "$HOME/Documents/.password-store";
    GOPATH = "$HOME/Documents/go";

    # Don't create files
    LESSHISTFILE = "-";

    # Make gpg-agent ssh work
    SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";

    # Misc Config
    EXA_STRICT = "1";
    MANPAGER = "nvim -c 'set ft=man'";
    RIPGREP_CONFIG_PATH = "/home/elf/.config/ripgreprc";
    NO_AT_BRIDGE = "1";

    # Common directories
    projects = "$HOME/Documents/projects";
    dotfiles = "$HOME/Documents/dotfiles";
    software = "$HOME/Documents/software";
    learning = "$HOME/Documents/learning";
    org = "$HOME/Documents/org";
    saved = "$HOME/Documents/org/saved";
  };
  initExtra = ''
    unalias -m '*'
    setopt cdable_vars
    setopt hist_find_no_dups

    alias -s git="git clone"

    function movie() {
      ${pkgs.tree}/bin/tree /run/media/elf/stuff/movies -L 2 -P "*$1*" --matchdirs --prune --ignore-case
    }
  '';
  history = {
    path = "/home/elf/.config/zsh/history";
    extended = true;
  };
  oh-my-zsh = {
    enable = true;
    theme = "agnoster";
    plugins = [ ];
  };
  shellAliases = {
    history = "omz_history";
    grep = "grep --text --color=auto";
    ls = "exa";
    tree = "exa -T";

    open = "xdg-open";
    pbcopy = "xclip -selection clipboard";
    pbpaste = "xclip -selection clipboard -o";

    music = "ncmpcpp -c /home/elf/.config/ncmpcpp/config";
    pass = ''EDITOR="nvim -u NONE" pass'';
  };
  loginExtra = ''
    . /etc/profile

    if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
      exec startx
    fi
  '';
}
