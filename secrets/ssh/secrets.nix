let
  user1 = "soranagano";
  user2 = "your-other-user"; # 必要に応じて追加
in
{
  "ssh/config.age".publicKeys = [
    user1
    user2
  ];
}