{ pkgs, ... }: {
  enable = false;
  extraPackages = epkgs: [
    epkgs.use-package
    epkgs.solarized-theme
    epkgs.evil
    epkgs.evil-collection
    epkgs.org
    epkgs.nix-mode
  ];
}
