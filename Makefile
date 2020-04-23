.PHONY: switch
switch:
	sudo mount -o remount,rw /boot && sudo nixos-rebuild switch -I nixos-config=/home/elf/Documents/dotfiles/nixos/configuration.nix && sudo mount -o remount,ro /boot

.PHONY: boot
boot:
	sudo mount -o remount,rw /boot && sudo nixos-rebuild boot -I nixos-config=/home/elf/Documents/dotfiles/nixos/configuration.nix && sudo mount -o remount,ro /boot

.PHONY: gen-cert
gen-cert:
	openssl req -x509 -nodes -newkey rsa:2048 -days 5000 -sha256 -keyout nixos/dnscrypt.pem -out nixos/dnscrypt.pem
