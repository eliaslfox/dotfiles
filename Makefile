.PHONY: switch
switch:
	sudo nixos-rebuild switch -I nixos-config=/home/elf/Documents/dotfiles/nixos/configuration.nix

.PHONY: boot
boot:
	sudo nixos-rebuild boot -I nixos-config=/home/elf/Documents/dotfiles/nixos/configuration.nix
