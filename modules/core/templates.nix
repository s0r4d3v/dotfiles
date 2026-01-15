{ config, ... }:
{
  flake.templates = {
    direnv = {
      path = ../../templates/direnv;
      description = "Cross-platform Nix development template with direnv support";
    };
  };
}
