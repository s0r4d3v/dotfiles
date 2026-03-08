{ inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    { config, pkgs, ... }:
    {
      # treefmt-nix configuration for unified formatting
      treefmt.config = {
        projectRootFile = "flake.nix";

        programs = {
          # Nix
          nixfmt.enable = true;

          # Shell scripts
          shellcheck.enable = true;
          shfmt = {
            enable = true;
            indent_size = 2;
          };

          # JavaScript/TypeScript/JSON/YAML/Markdown/HTML/CSS
          prettier = {
            enable = true;
            settings = {
              editorconfig = true;
            };
          };

          # Python
          ruff-format.enable = true;

          # Lua
          stylua.enable = true;

          # TOML
          taplo.enable = true;

          # General whitespace cleanup
          # deadnix.enable = true; # Remove dead Nix code
          # statix.enable = true; # Nix linter
        };

        settings = {
          formatter = {
            # Additional custom formatters can be added here
          };
        };
      };

      # Make treefmt available as formatter for `nix fmt`
      formatter = config.treefmt.build.wrapper;
    };
}
