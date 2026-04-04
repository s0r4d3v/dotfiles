{ config, pkgs, lib, username, ... }: {
  imports = [ ./shared.nix ];

  home.username      = username;
  home.homeDirectory = "/home/${username}";

  # Required for Home Manager on non-NixOS Linux
  targets.genericLinux.enable = true;

  # Set zsh as default login shell (home-manager can't write /etc/passwd directly).
  # Uses the profile symlink (~/.nix-profile/bin/zsh) rather than a raw /nix/store
  # path so the path is stable across upgrades and accepted by chsh.
  home.activation.setDefaultShell = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    nix_zsh="$HOME/.nix-profile/bin/zsh"
    if [[ -x "$nix_zsh" ]]; then
      desired="$nix_zsh"
    elif [[ -x "/usr/bin/zsh" ]]; then
      desired="/usr/bin/zsh"
      echo "Warning: nix zsh not available, falling back to $desired"
    else
      desired=""
      echo "No zsh found — skipping shell change."
    fi

    if [[ -n "$desired" ]]; then
      # chsh requires the shell to be listed in /etc/shells (pure bash read, no grep/awk)
      found=0; while IFS= read -r line; do [[ "$line" == "$desired" ]] && found=1 && break; done < /etc/shells
      if [[ $found -eq 0 ]]; then
        sudo sh -c "echo '$desired' >> /etc/shells" \
          || echo "Could not add $desired to /etc/shells — run manually: echo $desired | sudo tee -a /etc/shells && chsh -s $desired"
      fi
      current=""; while IFS=: read -r u _ _ _ _ _ sh; do [[ "$u" == "$USER" ]] && current="$sh" && break; done < /etc/passwd
      if [[ "$current" != "$desired" ]]; then
        chsh -s "$desired" \
          || echo "chsh failed — run manually: chsh -s $desired"
      fi
    fi
  '';

}
