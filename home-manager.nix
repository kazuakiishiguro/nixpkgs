{pkgs, lib, ...}: {
  home = rec {
    username="kishiguro";
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";
  };
  programs.home-manager.enable = true;
  
  home.packages = with pkgs; [
    age-plugin-yubikey
    bat
    curl
    htop
    mosh
    passage
    signal-desktop
    syncthing    
    wget
    xsel
    zoom-us    
  ];

  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -la";
      emacs = "emacs -nw";
    };
  };
  
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: with epkgs; [
      magit
      nix-mode
    ];
  };
  
  programs.firefox = {
    enable = true;
    profiles.kishiguro = {
      isDefault = true;
      settings = {
        "browser.startup.homepage" = "about:blank";
        "browser.toolbars.bookmarks.visibility" = "never";
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "Kazuaki Ishiguro";
    userEmail = "kazuakiishiguro@protonmail.com";
    signing = {
      key = "13d8b163975ec06e";
      signByDefault = true;
    };
    extraConfig = {
      github.user = "kazuakiishiguro";
    };
  };

  dconf.settings = {
    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
    };
  };
}
