{ ... }:
{
  flake.modules.homeManager.ssh =
    { homeDir, ... }:
    {
      programs.ssh = {
        enable = true;

        # Disable automatic default config (to avoid deprecation warning)
        enableDefaultConfig = false;

        # Include Colima SSH config
        includes = [ "${homeDir}/.colima/ssh_config" ];

        # Host-specific configurations
        matchBlocks = {
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

          "tanaka-site" = {
            hostname = "phiz.c.u-tokyo.ac.jp";
            user = "tanaka";
            port = 22;
            identityFile = [ "~/.ssh/tanaka-site" ];
          };

          # Default settings for all hosts
          "*" = {
            # デフォルトの SSH 秘密鍵（sops で配置される）
            identityFile = [ "~/.ssh/id_ed25519" ];

            # lemonade remote clipboard
            remoteForwards = [
              {
                bind.port = 2489;
                host.address = "127.0.0.1";
                host.port = 2489;
              }
            ];

            # Connection multiplexing (improves performance)
            controlMaster = "auto";
            controlPath = "~/.ssh/master-%r@%n:%p";
            controlPersist = "10m";

            # Keep connections alive
            serverAliveInterval = 60;
            serverAliveCountMax = 3;

            # Security and behavior defaults
            forwardAgent = false; # Override per-host as needed
            hashKnownHosts = false;
          };
        };
      };
    };
}
