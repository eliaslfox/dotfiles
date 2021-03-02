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

    # Temp Files
    LESSHISTFILE = "-";

    # Make gpg-agent ssh work
    SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";

    # Misc Config
    EXA_STRICT = "1";
    MANPAGER = "nvim -c 'set ft=man'";
    RIPGREP_CONFIG_PATH = "/home/elf/.config/ripgreprc";
    NO_AT_BRIDGE = "1";
  };
  dirHashes = {
    projects = "$HOME/Documents/projects";
    dotfiles = "$HOME/Documents/dotfiles";
    software = "$HOME/Documents/software";
    learning = "$HOME/Documents/learning";
  };
  initExtra = ''
    unalias -m '*'

    alias -s git="git clone"

    function movie() {
      ${pkgs.tree}/bin/tree /run/media/elf/stuff/movies -L 2 -P "*$1*" --matchdirs --prune --ignore-case
    }
  '';
  history = {
    path = "/home/elf/.config/zsh/history";
    extended = true;
  };
  shellAliases = {
    grep = "grep --text --color=auto";
    ls = "exa";
    g = "git";
    stack = "stack --stack-root ~/.local/share/stack";
    ns = "nix-shell --command zsh";

    open = "xdg-open";
    pbcopy = "xclip -selection clipboard";
    pbpaste = "xclip -selection clipboard -o";

    pass = ''EDITOR="nvim -u NONE" pass'';
  };
  loginExtra = ''
    . /etc/profile

    if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
      exec startx
    fi
  '';
  oh-my-zsh = {
    enable = true;
    plugins = [ ];
  };
  plugins = [
    {
      name = "powerlevel10k";
      src = pkgs.zsh-powerlevel10k;
      file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    }
    {
      name = "p10k-config";
      src = ./p10k;
      file = "p10k.zsh";
    }
  ];
}
