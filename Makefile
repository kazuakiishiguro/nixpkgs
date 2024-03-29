PROFILE=/nix/var/nix/profiles/system

all: build

build:
	@echo "Building..."
	sudo nixos-rebuild switch --flake .#fw --show-trace

dev:
	rm flake.lock
	nix run nixpkgs#home-manager -- switch --flake .#kishiguro

clean:
	nix-collect-garbage -d

delete:
	sudo nix-env --delete-generations --profile ${PROFILE} old

update:
	nix flake update
