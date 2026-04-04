{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch = {
      enable = true;
      searchUpKey = [ "^[[A" ];
      searchDownKey = [ "^[[B" ];
    };
    plugins = [
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
      {
        name = "zsh-vi-mode";
        src = "${pkgs.zsh-vi-mode}/share/zsh-vi-mode";
      }
    ];
    history = {
      path = "${config.home.homeDirectory}/.zsh_history";
      size = 100000;
      save = 100000;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };
    shellAliases = {
      vim = "nvim";
      ls = "eza --group-directories-first";
      ll = "eza -la --git --group-directories-first";
      lt = "eza --tree --git-ignore -I '.git|node_modules|.cache|__pycache__|.DS_Store|*.pyc|dist|.next' --group-directories-first";
      cat = "bat --style=plain";
      find = "fd";
      du = "dust";
      df = "duf";
      ps = "procs";
      cd = "z";
      cdi = "zi";
      ".." = "cd ..";
      "..." = "cd ../..";
    };
    initContent = ''
      eval "$(zoxide init zsh)"
      eval "$(mise activate zsh)"
      # Re-bind fzf keys after zsh-vi-mode initialises (zvm overwrites Ctrl+R/T, Alt+C)
      zvm_after_init_commands+=("source ${pkgs.fzf}/share/fzf/key-bindings.zsh")

      # Jump to a ghq repo or gwq worktree with fzf; renames tmux window on select
      repo() {
        local dir
        dir=$(
          {
            ghq list --full-path
            gwq list -g --json 2>/dev/null | jq -r '.[].path' 2>/dev/null
          } \
            | sort -u \
            | fzf --height 60% --reverse --prompt='repo/worktree > ' \
                  --preview='git -C {} log --oneline -10 2>/dev/null; echo; eza -1 --group-directories-first --color=always {} 2>/dev/null | head -20'
        )
        [[ -z "$dir" ]] && return
        z "$dir"
        [[ -n $TMUX ]] && tmux rename-window "$(basename "$dir")"
      }

      # Checkout a PR into a dedicated worktree
      # Usage: wpr <pr-number>
      wpr() {
        [[ -z "$1" ]] && echo "Usage: wpr <pr-number>" && return 1
        local branch
        branch=$(gh pr view "$1" --json headRefName -q .headRefName)
        gwq add -b "$branch"
        local wtdir
        wtdir=$(gwq list -g --json 2>/dev/null | jq -r --arg b "$branch" '.[] | select(.branch == $b) | .path')
        [[ -n "$wtdir" ]] && z "$wtdir"
        [[ -n $TMUX ]] && tmux rename-window "$branch"
      }

      # Create a new Jupyter notebook and open in nvim
      nb() {
        local name lang display kernel

        printf "Notebook name: "
        read -r name
        [[ -z "$name" ]] && echo "Aborted." && return 1
        name="''${name%.ipynb}"

        if [[ -f "''${name}.ipynb" ]]; then
          echo "''${name}.ipynb already exists, opening..."
          nvim "''${name}.ipynb"
          return
        fi

        printf "Kernel language (python): "
        read -r lang
        lang="''${lang:-python}"

        case "$lang" in
          python)  display="Python 3"; kernel="python3" ;;
          r)       display="R";        kernel="ir" ;;
          julia)   display="Julia";    kernel="julia-1" ;;
          *)       display="$lang";    kernel="$lang" ;;
        esac

        cat > "''${name}.ipynb" << 'NBEOF'
      {
       "cells": [
        {
         "cell_type": "code",
         "execution_count": null,
         "metadata": {},
         "outputs": [],
         "source": []
        }
       ],
       "metadata": {
        "kernelspec": {
         "display_name": "DISPLAY_PLACEHOLDER",
         "language": "LANG_PLACEHOLDER",
         "name": "KERNEL_PLACEHOLDER"
        },
        "language_info": {
         "name": "LANG_PLACEHOLDER"
        }
       },
       "nbformat": 4,
       "nbformat_minor": 5
      }
      NBEOF
        # Substitute placeholders (avoids heredoc indentation issues)
        ${pkgs.sd}/bin/sd 'DISPLAY_PLACEHOLDER' "$display" "''${name}.ipynb"
        ${pkgs.sd}/bin/sd 'LANG_PLACEHOLDER'    "$lang"    "''${name}.ipynb"
        ${pkgs.sd}/bin/sd 'KERNEL_PLACEHOLDER'  "$kernel"  "''${name}.ipynb"
        echo "Created ''${name}.ipynb ($display kernel)"
        nvim "''${name}.ipynb"
      }
    '';
  };
}
