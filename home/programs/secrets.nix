{ config, ... }:
{
  # Key must exist at ~/.config/sops/age/keys.txt before first run.
  # To add a secret: edit secrets/secrets.yaml (sops-encrypted).
  # Access path at runtime: config.sops.secrets.<name>.path
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;
    secrets = {
      "ssh/id_ed25519" = {
        path = "${config.home.homeDirectory}/.ssh/id_ed25519";
        mode = "0600";
      };
      "ssh/id_ed25519_pub" = {
        path = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
        mode = "0644";
      };
      "ssh/id_rsa" = {
        path = "${config.home.homeDirectory}/.ssh/id_rsa";
        mode = "0600";
      };
      "ssh/id_rsa_pub" = {
        path = "${config.home.homeDirectory}/.ssh/id_rsa.pub";
        mode = "0644";
      };
      "ssh/tanaka-site" = {
        path = "${config.home.homeDirectory}/.ssh/tanaka-site";
        mode = "0600";
      };
      "ssh/tanaka-site_pub" = {
        path = "${config.home.homeDirectory}/.ssh/tanaka-site.pub";
        mode = "0644";
      };
      "ssh/m02uku_pem" = {
        path = "${config.home.homeDirectory}/.ssh/m02uku.pem";
        mode = "0600";
      };
      "ssh/tanaka_ppk" = {
        path = "${config.home.homeDirectory}/.ssh/tanaka.ppk";
        mode = "0600";
      };
      "ssh/config" = {
        path = "${config.home.homeDirectory}/.ssh/config";
        mode = "0600";
      };
      "gh/hosts" = {
        path = "${config.home.homeDirectory}/.config/gh/hosts.yml";
        mode = "0600";
      };
      "git/name" = { };
      "git/email" = { };
    };
  };
}
