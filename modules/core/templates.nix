{ ... }:
{
  flake.templates = {
    devenv = {
      path = ../../templates/devenv;
      description = "Fast, declarative development environment with devenv";
    };
  };
}
