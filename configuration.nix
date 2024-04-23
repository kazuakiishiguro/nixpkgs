{ inputs, pkgs,... }:{
  imports =
    [
     ./hardware-configuration.nix
    ]
    ++ [
      inputs.xremap.nixosModules.default
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
    
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Tokyo";
  sound.enable = true;
  
  hardware = {
    bluetooth.enable = true;
    pulseaudio.enable = true;
  };
  
  services = {
    xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
      libinput.touchpad = {
        clickMethod = "clickfinger";
        naturalScrolling = true;
        tapping = false;
      };
    };
    printing.enable = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
    inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [anthy];
    };    
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
    ];
    fontconfig.defaultFonts = {
      serif = ["Noto Serif CJK JP"];
      sansSerif = ["Noto Sans CJK JP"];
    };
  };  
  
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
  
  users.users.kishiguro = {
    isNormalUser = true;
    description = "kishiguro";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      age-plugin-yubikey
      passage
      syncthing
      wget
      xsel
      zoom-us
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = with pkgs; [];
  };
  
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services = {
    fwupd.enable = true;
    pcscd.enable = true;
    tailscale.enable = true;    
  };

  services.xremap = {
    userName = "kishiguro";
    serviceMode = "system";
    config = {
      modmap = [
        {
	  name = "No CapsLock";
	  remap = {
	    CapsLock = "Ctrl_L";
	  };
	}
      ];
    };
  };  
  
  system.stateVersion = "23.11";
}
