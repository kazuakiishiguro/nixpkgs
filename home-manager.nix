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
