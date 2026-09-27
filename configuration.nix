{ config, pkgs, inputs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix 
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true; 

  networking.hostName = "anyanya"; 
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  services.resolved.enable = true;

  time.timeZone = "Europe/Samara";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };


  fileSystems."/mnt/mydrive" = {
    device = "/dev/disk/by-uuid/fb772751-2328-4439-8bee-678e05923a00";
    fsType = "ext4";
    options = [ "nofail"];
  };

  users.users.anyanya = {
    isNormalUser = true;
    description = "anyanya";
    extraGroups = [ "networkmanager" "wheel" "gamemode" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  


  environment.systemPackages = with pkgs; [
    wget
    neovim
    gparted
    baobab
    git
    polkit_gnome
    xclip
    (stdenv.mkDerivation rec {
      name = "vxwm";
      src = pkgs.fetchgit {
        url = "https://codeberg.org/wh1tepearl/vxwm.git";
        rev = "refs/heads/main";
        # run nixos-rebuild switch and copy SHA-256 from error message
        sha256 = "sha256-W7BYpvU1oBfHN3QzZDvDhWVEQ4w/1hKRFdiDzpqfhJ8="; 
      };
      prePatch = ''
        cp ${./config.def.h} config.def.h
      '';
      buildInputs = with pkgs; [ libx11 libxft libxinerama ];
      makeFlags = [ "PREFIX=$(out)" ];
    })
    
  ];

  programs.zsh.enable = true;
  programs.yazi.enable = true;
  programs.gamemode.enable = true;
  programs.amnezia-vpn.enable =true;
  programs.thunar.enable = true;
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/etc/nixos/"; # sets NH_OS_FLAKE variable for you

  };

  programs.steam =  {
    enable = true;
    remotePlay.openFirewall = true; 
    dedicatedServer.openFirewall = true;
    protontricks.enable = true;
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    glib
    mesa
  ];

  programs.appimage = {
    enable = true;
    binfmt = true;
    package = pkgs.appimage-run.override {
      extraPkgs = pkgs: [ pkgs.xcbutilcursor pkgs.zstd pkgs.libxkbfile ]; 
    };
  };

  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.xkb.layout = "us,ru";
  services.xserver.xkb.options = "grp:alt_shift_toggle";
  services.xserver.videoDrivers = [ "nvidia" ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  }; 

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    nvidiaSettings = false;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };

  services.dbus.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.zerotierone = {
    enable = false;
    joinNetworks = [ "3b19b3a716d876f3" ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "gtk";
  };


  system.stateVersion = "26.05"; # Did you read the comment?

}
