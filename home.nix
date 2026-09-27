{ config, pkgs, ... }:

{
  home.username = "anyanya"; 
  home.homeDirectory = "/home/anyanya";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    fastfetch
    feh
    imv
    speedtest-cli
    unrar
    peazip
    qbittorrent
    obsidian
    librewolf
    btop-cuda
    mpv
    flameshot
    wineWow64Packages.stable
    ayugram-desktop
    vesktop
    rofi
    pavucontrol
    libreoffice-qt
    hunspell
    fzf
    picom
    dunst
    libnotify
    qalculate-qt
  ];

  programs.git = {
    enable = true;
    settings.user.name = "anyanya";
    settings.user.email = "anyanya200@proton.me";
  };

  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      font_family = "JetBrainsMono Nerd Font";
      font_size = "11.0";
      background_opacity = "0.6";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    shellAliases = { 
      update = "sudo nixos-rebuild switch --flake /etc/nixos/.#anyanya";
      upgrade = "cd /etc/nixos && nix flake update && sudo nixos-rebuild switch --flake .#anyanya";
      f = "fastfetch";
    };
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell"; 
      plugins = [ 
        "git" 
        "sudo"
      ];
    };
  };

   home.file.".xinitrc" = {
    executable = true;
    text = ''
      eval $(dbus-launch --sh-syntax)
      feh --bg-fill /home/anyanya/Pictures/Wallpapers/wallpapers.png
      ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
      exec picom &
      exec xclip &
      exec pipewire &
      exec pipewire-pulse &
      exec dunst &
      exec vxwm 
    '';
  };
  

  programs.home-manager.enable = true;
}
