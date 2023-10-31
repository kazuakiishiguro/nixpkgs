ARG=--extra-experimental-features "nix-command flakes"

all: build

build:
	@echo "Building..."
	nix develop ${ARG}

clean:
	nix-collect-garbage -d
