{pkgs, ...}: {
  home = rec {
    username="kishiguro";
    homeDirectory = "/home/${username}";
    stateVersion = "23.11";
  };
  programs.home-manager.enable = true;
  
  home.packages = with pkgs; [
    bat
  ];

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases= {
      emacs = "emacs -nw";
    };
  };

  programs.firefox = {
    enable = true;
    profiles.kishiguro = {
      isDefault = true;
      settings = {
        "browser.startup.homepage" = "about:blank";
      };
    };
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
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
}
