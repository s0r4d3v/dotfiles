{ config, lib, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      url."git@github.com:".insteadOf = "https://github.com/";
    };
    includes = [ { path = "${config.home.homeDirectory}/.config/git/identity"; } ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options.navigate = true;
  };

  home.activation.writeGitIdentity = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${config.home.homeDirectory}/.config/git"
    printf '[user]\n\tname = %s\n\temail = %s\n' \
      "$(cat ${config.sops.secrets."git/name".path})" \
      "$(cat ${config.sops.secrets."git/email".path})" \
      > "${config.home.homeDirectory}/.config/git/identity"
    chmod 600 "${config.home.homeDirectory}/.config/git/identity"
  '';
}
