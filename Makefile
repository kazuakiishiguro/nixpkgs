all: build

build:
	@echo "Building..."
	nix develop --extra-experimental-features "nix-command flakes"

clean:
	nix-collect-garbage -d
