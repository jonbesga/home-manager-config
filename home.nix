{ config, pkgs, ... }:

{
  home.username = "jon";
  home.homeDirectory = "/home/jon";

  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    nerd-fonts.aurulent-sans-mono
    bat
    vim
    jq
    tmux
    starship
    direnv
  ];



  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jon/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };


  programs.home-manager.enable = true;

  programs.alacritty = {
    enable = true;
    settings = {
      terminal.shell = {
        program = "${pkgs.tmux}/bin/tmux";
        args = ["new-session"];
      };
      font = {
        size = 16.0;
      };
      hints = {
        enabled = [
          {
            regex = ''(ipfs:|ipns:|magnet:|mailto:|gemini://|gopher://|https://|http://|news:|file:|git://|ssh:|ftp://)[^\\u0000-\\u001F\\u007F-\\u009F<>"\\s{-}\\^⟨⟩`]+''; 
            action = "Copy";
            post_processing = true;
            mouse.enabled = true;
          }
        ];
      };
      window = {
        padding = {
          x = 10;
          y = 10;
        };
      };
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      line_break = {
        disabled = true;
      };

      python = {
        disabled = true;
      };

      hostname = {
        disabled = false;
        format = "@[$hostname](dimmed)";
        ssh_only = false;
      };
    };
  };

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      source ${pkgs.tmux}/share/bash-completion/completions/tmux

      HISTFILESIZE=100000
      HISTSIZE=10000

      export EDITOR=vim

      [[ $- != *i* ]] && return

      eval "$(direnv hook bash)"

      # Added by LM Studio CLI (lms)
      export PATH="$PATH:/home/jon/.lmstudio/bin"
      # End of LM Studio CLI section

      [[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

      # Created by `pipx` on 2025-05-31 09:16:46
      export PATH="$PATH:/home/jon/.local/bin"

      export PATH="$PATH:$HOME/.nix-profile/bin"

      # Arrow up/down to search history by current prefix
      bind '"\e[A": history-search-backward'
      bind '"\e[B": history-search-forward'

      eval "$(starship init bash)"

    '';
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = ''
      set -g mouse on
      set -g history-limit 10000
    '';
  };
}
