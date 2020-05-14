{ pkgs, ... }: {
  enable = true;
  extraPackages = epkgs: [
    epkgs.solarized-theme
    epkgs.use-package
    epkgs.smart-mode-line
    epkgs.smart-mode-line-powerline-theme
    epkgs.evil
    epkgs.helm
  ];
}
