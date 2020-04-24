{
  enable = true;
  enableCompletion = true;
  dotDir = ".config/zsh";
  autocd = false;
  sessionVariables = {
    /* Basic config */
    DEFAULT_USER = "elf";
    EDITOR = "nvim";

    /* Setup XDG */
    XDG_CONFIG_HOME="$HOME/.config";
    XDG_CACHE_HOME="$HOME/.cache";
    XDG_DATA_HOME="$HOME/.local/share";

    /* Use XDG */
    GNUPGHOME="$HOME/.config/gnupg";
    NIXOPS_STATE="$HOME/.config/nixops/deployments.nixops";
    INPUTRC="$HOME/.config/readline/inputrc";
    NPM_CONFIG_USERCONFIG="$HOME/.config/npm/npmrc";

    /* Handle temp ~ */
    PASSWORD_STORE_DIR = "$HOME/Documents/password-store";
    GOPATH="$HOME/Documents/go";

    /* Don't create files */
    LESSHISTFILE="-";
  };
  initExtra = ''
    unalias -m '*'
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';
  history = {
    path = ".cache/zsh_history";
    extended = true;
  };
  oh-my-zsh = {
    enable = true;
    theme = "agnoster";
    plugins = [];
  };
  shellAliases = {
    history="omz_history";
    movie = "/run/media/elf/stuff/movies/find.sh";
    mixer = "ncpamixer";
    music = "ncmpcpp -c /home/elf/.config/ncmpcpp/config";
    open = "xdg-open";
    pbcopy = "xclip -selection clipboard";
    pbpaste = "xclip -selection clipboard -o";
    pass = "EDITOR=nano pass";
  };
}
