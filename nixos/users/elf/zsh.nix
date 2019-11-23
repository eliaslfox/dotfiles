{
  enable = true;
  enableCompletion = true;
  dotDir = ".config/zsh";
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

    PATH="/home/elf/.cache/npm/bin:$PATH";
  };
  initExtra = ''
    # Setup gpg agent
    export GPG_TTY="$(tty)"
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';
  history = {
    path = ".cache/zsh_history";
  };
  oh-my-zsh = {
    enable = true;
    theme = "agnoster";
    plugins = [];
  };
  shellAliases = {
    movie = "/run/media/elf/stuff/movies/find.sh";
    g = "git";
    mixer = "ncpamixer";
    music = "ncmpcpp";
    open = "xdg-open";
    pbcopy = "xclip -selection clipboard";
    pbpaste = "xclip -selection clipboard -o";
    pubkey = "cat ~/.ssh/id_rsa.pub | xclip -selection clipboard";
    cp = "cp -i";
    mv = "mv -i";
    pass = "EDITOR=nano pass";
  };
}
