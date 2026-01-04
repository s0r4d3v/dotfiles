let
  # SSH public keys for decryption (using Ed25519 for agenix compatibility)
  userKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII6tcYH6tposlZf/+ufwOlEHvgMtmKTFCTQbmMG20Zg/ agenix"
  ];
in
{
  "config.age".publicKeys = userKeys;
}