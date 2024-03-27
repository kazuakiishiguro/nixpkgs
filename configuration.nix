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
  boot.initrd.luks.devices."luks-1e3fdc47-577a-45ed-b3d9-f70e8b06f53a".device = "/dev/disk/by-uuid/1e3fdc47-577a-45ed-b3d9-f70e8b06f53a";
    
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Tokyo";
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  
  services = {
    xserver = {
      enable = true;
      desktopManager = {
        xterm.enable = false;
      };
      displayManager = {
        defaultSession = "none+i3";
      };
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu
          i3status
        ];
      };
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
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = with pkgs; [
      firefox
    ];
  };
  
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services = {
    emacs = {
      enable = true;
      package = pkgs.emacs;
    };
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
