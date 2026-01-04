{ ... }:
{
  flake.modules.homeManager.containers = { pkgs, ... }: {
    home.packages = with pkgs; [
      colima    # Docker on macOS/Linux without Docker Desktop
      docker    # Docker CLI (colima provides the daemon)
    ];
  };
}
