{ ... }:
{
  flake.modules.homeManager.zoom = { pkgs, ... }: {
    home.packages = [ pkgs.zoom-us ];

    # Zoom privacy & security settings (configure in app):
    # - Settings > Video: Disable "HD" if bandwidth is limited
    # - Settings > Audio: Test speaker and microphone
    # - Settings > General: Disable "Add Zoom to macOS menu bar"
    # - Settings > Privacy: Review camera/microphone permissions
    #
    # For enterprise: SSO settings are configured through the app
  };
}
