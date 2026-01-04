{ ... }:
{
  flake.modules.homeManager.ssh = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          forwardAgent = false;
          addKeysToAgent = "no";
          compression = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
        };
        "aces-ubuntu-2" = {
          hostname = "150.249.250.83";
          user = "soranagano";
          forwardAgent = true;
          port = 11022;
        };
        "aces-desktop-24" = {
          hostname = "192.168.0.219";
          user = "soranagano";
          proxyCommand = "ssh aces-ubuntu-2 -W %h:%p";
          forwardAgent = true;
          serverAliveInterval = 60;
          serverAliveCountMax = 5;
        };
        "aces-desktop-13" = {
          hostname = "192.168.0.242";
          user = "soranagano";
          proxyCommand = "ssh aces-ubuntu-2 -W %h:%p";
          forwardAgent = true;
          serverAliveInterval = 60;
          serverAliveCountMax = 5;
        };
      };
    };
  };
}