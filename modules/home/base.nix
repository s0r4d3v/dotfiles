{ inputs, ... }:
{
  flake.modules.homeManager.base =
    {
      user,
      homeDir,
      agenix,
      pkgs,
      ...
    }:
    {
      home.username = user;
      home.homeDirectory = homeDir;
      home.stateVersion = "25.11";
      programs.home-manager.enable = true;
      home.sessionVariables = {
        DOTFILES_PATH = "${homeDir}/ghq/github.com/s0r4d3v/dotfiles";
      };
      home.activation.decryptSSH = inputs.home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if [ -f ${homeDir}/.ssh/id_ed25519 ]; then
          ${pkgs.age}/bin/age -d -i ${homeDir}/.ssh/id_ed25519 ../../secrets/ssh/config.age > ${homeDir}/.ssh/config
          chmod 600 ${homeDir}/.ssh/config
        fi
      '';
    };
}
