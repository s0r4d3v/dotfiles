{ ... }:
{
  flake.modules.homeManager.ai-tools = { pkgs, ... }: {
    home.packages = with pkgs; [
      # AI CLI tools
      opencode    # AI model interaction CLI
    ];
  };
}