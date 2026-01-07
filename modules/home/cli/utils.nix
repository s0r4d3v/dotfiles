{ ... }:
{
  flake.modules.homeManager.utils =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # Modern ls/cat
        eza
        bat

        # JSON/HTTP
        jq
        curl
        wget
        xh # Modern curl for APIs

        # System monitoring
        btop # Modern htop
        dust # Modern du
        duf # Modern df

        # Productivity
        tldr # Simplified man pages
        trash-cli # Safe rm
        entr # Run command on file change
        sshfs # Mount remote directories over SSH
        comma # Run commands without installing
      ];
    };
}
