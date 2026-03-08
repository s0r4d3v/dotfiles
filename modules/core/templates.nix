{ config, ... }:
{
  flake.templates = {
    direnv = {
      path = ../../templates/direnv;
      description = "Cross-platform Nix development template with direnv support";
    };
    devenv = {
      path = ../../templates/devenv;
      description = "Fast, declarative development environment with devenv and direnv";
    };
  };
}
