add:
	@git add .
titan: add
	sudo nixos-rebuild switch --flake .#titan
