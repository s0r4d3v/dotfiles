{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withPython3 = true;
    extraPython3Packages =
      ps: with ps; [
        pynvim
        jupyter-client
        ipykernel
        nbformat
        cairosvg
      ];
    extraPackages = [ pkgs.imagemagick ];
  };

  xdg.configFile."nvim" = {
    source = ../../config/.config/nvim;
    recursive = true;
  };
}
