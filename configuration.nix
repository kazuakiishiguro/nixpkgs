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
      windowManager.dwm.enable = true;
      displayManager.sessionCommands = ''
            xsetroot -solid  "#000000" &
            slstatus &
            export XIM="ibus"
            export GTK_IM_MODULE="ibus"
            export QT_IM_MODULE="xim"
            export XMODIFIERS="@im=ibus"
            ibus-daemon -d -x &
            export XSESSION_PID="$$"
            exec dwm > ~/.dwm.log
      '';
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    displayManager.defaultSession = "none+dwm";
    libinput.touchpad = {
      clickMethod = "clickfinger";
      naturalScrolling = true;
      tapping = false;
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
    packages = with pkgs; [];
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [
      (final: prev: {
        dwm = prev.dwm.overrideAttrs (old: {
          src = /home/kishiguro/fun/suckless/dwm;
          patches = [
            /home/kishiguro/fun/suckless/dwm/patches/dwm-center-6.2.diff
            /home/kishiguro/fun/suckless/dwm/patches/dwm-hide_vacant_tags-6.3.diff
          ];
        });
      })
    ];
  };

  environment = {
    systemPackages = with pkgs; [
      xorg.libX11
      (dmenu.overrideAttrs {
        src = /home/kishiguro/fun/suckless/dmenu;
      })
      (slstatus.overrideAttrs {
        src = /home/kishiguro/fun/suckless/slstatus;
      })
      (st.overrideAttrs {
        src = /home/kishiguro/fun/suckless/st;
        patches = [
          /home/kishiguro/fun/suckless/st/patches/st-scrollback-0.8.5.diff
        ];
      })
    ];
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
  system.stateVersion = "24.11";
}
