{
  enable = true;
  enableCompletion = true;
  defaultKeymap = "viins";
  dotDir = ".config/zsh";
  sessionVariables = {
    DEFAULT_USER = "elf";
    PASSWORD_STORE_DIR = "$HOME/Documents/password-store";
    GNUPGHOME="$HOME/.config/gnupg";
    EDITOR = "nvim";
    GOPATH="$HOME/Documents/go";
    NIXOPS_STATE="$HOME/.config/nixops/deployments.nixops";
  };
  initExtra = ''
    export GPG_TTY="$(tty)"
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

    function venv() {
      . ~/Documents/software/$1/venv/bin/activate
    }

    function c() {
      if [ -z $1 ]; then
        clear
      elif [ -d $1 ]; then
        cd $1
      else
        cat $1
      fi
    }
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
  };
}
