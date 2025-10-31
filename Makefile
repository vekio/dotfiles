add:
	@git add .
titan: add
	sudo nixos-rebuild switch --flake .#titan
update:
	@sudo nix flake update
upgrade: update titan
