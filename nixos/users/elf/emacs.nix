{ pkgs, ... }:

let
  myEmacs = pkgs.emacs25-nox;
  emacsWithPackages = (pkgs.emacsPackagesNgGen myEmacs).emacsWithPackages; 
in
  emacsWithPackages (epkgs: [
    epkgs.orgPackages.org
  ])
