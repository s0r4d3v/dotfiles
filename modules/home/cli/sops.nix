{ ... }:
{
  flake.modules.homeManager.sops =
    { config, lib, ... }:
    {
      # SOPS (Secrets OPerationS) configuration
      #
      # To use sops-nix:
      # 1. Install age or sops: already included in this config
      # 2. Generate age key: age-keygen -o ~/.config/sops/age/keys.txt
      # 3. Create .sops.yaml in your dotfiles root with age public key
      # 4. Create secrets/secrets.yaml and encrypt it: sops secrets/secrets.yaml
      # 5. Uncomment and configure the settings below

      # Uncomment to enable sops-nix
      # sops = {
      #   defaultSopsFile = ./secrets/secrets.yaml;
      #   validateSopsFiles = false;
      #
      #   age = {
      #     keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      #     generateKey = true;
      #   };
      #
      #   secrets = {
      #     # Example: GitHub personal access token
      #     # "github-token" = {
      #     #   path = "${config.home.homeDirectory}/.config/gh/token";
      #     # };
      #
      #     # Example: SSH private key
      #     # "ssh-private-key" = {
      #     #   path = "${config.home.homeDirectory}/.ssh/id_ed25519";
      #     # };
      #   };
      # };

      # Install age for sops encryption
      home.packages = lib.mkIf (builtins.pathExists ./secrets) [
        config.programs.nixvim.package.pkgs.age
        config.programs.nixvim.package.pkgs.sops
      ];
    };
}
