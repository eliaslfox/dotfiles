.PHONY: install
install:
	cd nixos && find . -type d -exec mkdir -p /etc/nixos/{} \;
	cd nixos && find . -type f -exec ln -sf `pwd`/{} /etc/nixos/{} \;

.PHONY: switch
switch:
	sudo nixos-rebuild switch -I nixos-config=/home/elf/Documents/dotfiles/nixos/configuration.nix

.PHONY: boot
boot:
	sudo nixos-rebuild boot -I nixos-config=/home/elf/Documents/dotfiles/nixos/configuration.nix
