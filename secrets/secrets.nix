let
  soranagano = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII6tcYH6tposlZf/+ufwOlEHvgMtmKTFCTQbmMG20Zg/ agenix";
in
{
  "secrets/ssh/config.age".publicKeys = [
    soranagano
  ];
}