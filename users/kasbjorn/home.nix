{ config, pkgs, ...}:

{

  imports = [ 
		./modules/ssh
		./dotfiles 
	];

    home.username = "kasbjorn";

    home.packages = [
		  pkgs.mpv
		  pkgs.google-chrome
		  pkgs.imagemagick
		  pkgs.gh
		  pkgs.gimp
		  pkgs.gnome-keyring
		  pkgs.yt-dlp
		
		  pkgs.sbcl
		  pkgs.guile
		  pkgs.picolisp
      pkgs.clojure

		  pkgs.signal-desktop
		  pkgs.obs-studio
	  ];

	  services.emacs = {
      enable = true;
      package = with pkgs; (
        (emacsPackagesFor emacs).emacsWithPackages (
          epkgs: [ epkgs.vterm ]
        )
      );
    };

	programs.emacs = {
	  enable = true;
	  package = pkgs.emacs;
	};

  programs.zsh = {
	  enable = true;
		enableCompletion = true;
		oh-my-zsh = {
      enable = true;
      plugins = [ "git" "direnvs" ];
      theme = "robbyrussell";
    };

    shellAliases = {
			update = "sudo nixos-rebuild switch";
			bat = "acpi";
			emacs = "emacsclient -c";
		};
    initExtraBeforeCompInit = ''
                            autoload -U add-zsh-hook
                            add-zsh-hook -Uz chpwd (){ print -Pn "\e]2;%2~\a" }
    '';
    
    initExtra  = ''
                vterm_printf() {
                               if [ -n "$TMUX" ] \
                                  && { [ "''${TERM%%-*}" = "tmux" ] \
                                  || [ "''${TERM%%-*}" = "screen" ]; }; then
                                     printf "\ePtmux;\e\e]%s\007\e\\" "$1"
                               elif [ "''${TERM%%-*}" = "screen" ]; then
                                    printf "\eP\e]%s\007\e\\" "$1"
                               else
                                    printf "\e]%s\e\\" "$1"
                               fi
                }
   '';
 };
  
  
	programs.gpg.enable = true;

  services.gpg-agent = {
  		enable = true;
  		enableSshSupport = true;
		pinentryPackage = pkgs.pinentry-curses;
	};


  programs.kitty = {
	  enable = true;
		settings = {
		  font_family = "Inconsolata";
			font_size = "12";
			tab_bar_edge = "top";
		  tab_bar_style = "powerline";
			tab_powerline_style = "angled";
			allow_remote_control = "yes";
			shell_integration = "enabled";
			linux_display_server = "x11";
    };
		extraConfig = "include ./nord.conf";
	};
	

    home.stateVersion = "24.05";

}
