{ ... }:
{
  flake.modules.homeManager.opencode = { pkgs, ... }: {
    home.packages = with pkgs; [
      # AI CLI tools
      opencode    # AI model interaction CLI
    ];
  };
}