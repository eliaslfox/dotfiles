.PHONY: switch
switch:
	sudo nixos-rebuild switch -I nixos-config=/home/elf/Documents/dotfiles/nixos/configuration.nix

.PHONY: boot
boot:
	sudo nixos-rebuild boot -I nixos-config=/home/elf/Documents/dotfiles/nixos/configuration.nix

.PHONY: gen-cert
gen-cert:
	openssl req -x509 -nodes -newkey rsa:2048 -days 5000 -sha256 -keyout nixos/dnscrypt.pem -out nixos/dnscrypt.pem
