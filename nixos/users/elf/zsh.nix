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
    NPM_CONFIG_USERCONFIG="$HOME/.config/npm/npmrc";
    STACK_ROOT="$HOME/.local/share/stack";
    XCOMPOSECACHE="$HOME/.cache/compose-cache";

    /* Handle temp ~ */
    PASSWORD_STORE_DIR = "$HOME/Documents/password-store";
    GOPATH="$HOME/Documents/go";

    /* Don't create files */
    LESSHISTFILE="-";
  };
  initExtra = ''
    unalias -m '*'
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

    function movie() {
      tree /run/media/elf/stuff/movies -L 2 -P "*$1*" --matchdirs --prune --ignore-case
    }

    function physexec() {
      sudo ip netns exec phys su elf 
    }

    function netns() {
      ip netns identify $$
    }
  '';
  history = {
    path = "/home/elf/.cache/zsh_history";
    extended = true;
  };
  oh-my-zsh = {
    enable = true;
    theme = "agnoster";
    plugins = [];
  };
  shellAliases = {
    history="omz_history";
    ls="ls --color=tty";
    grep="grep --text --color=auto";

    mixer = "ncpamixer";
    music = "ncmpcpp -c /home/elf/.config/ncmpcpp/config";
    open = "xdg-open";
    pbcopy = "xclip -selection clipboard";
    pbpaste = "xclip -selection clipboard -o";
    pass = "EDITOR=nano pass";
  };
}
