{ ... }:
{
  flake.modules.homeManager.karabiner =
    { pkgs, lib, ... }:
    lib.mkIf pkgs.stdenv.isDarwin {
      home.packages = with pkgs; [ karabiner-elements ];

      xdg.configFile."karabiner/karabiner.json".text = ''
        {
            "profiles": [
                {
                    "complex_modifications": {
                        "rules": [
                            {
                                "description": "Caps Lockを、英数・かなのトグルに変更する",
                                "manipulators": [
                                    {
                                        "conditions": [
                                            {
                                                "input_sources": [{ "language": "ja" }],
                                                "type": "input_source_if"
                                            }
                                        ],
                                        "from": {
                                            "key_code": "caps_lock",
                                            "modifiers": { "optional": ["any"] }
                                        },
                                        "to": [{ "key_code": "japanese_eisuu" }],
                                        "type": "basic"
                                    },
                                    {
                                        "conditions": [
                                            {
                                                "input_sources": [{ "language": "en" }],
                                                "type": "input_source_if"
                                            }
                                        ],
                                        "from": {
                                            "key_code": "caps_lock",
                                            "modifiers": { "optional": ["any"] }
                                        },
                                        "to": [{ "key_code": "japanese_kana" }],
                                        "type": "basic"
                                    }
                                ]
                            },
                            {
                                "description": "escキーを押したときに、英数キーも送信する（vim用）",
                                "manipulators": [
                                    {
                                        "from": { "key_code": "escape" },
                                        "to": [
                                            { "key_code": "escape" },
                                            { "key_code": "japanese_eisuu" }
                                        ],
                                        "type": "basic"
                                    }
                                ]
                            }
                        ]
                    },
                    "name": "Default profile",
                    "selected": true,
                    "virtual_hid_keyboard": { "keyboard_type_v2": "ansi" }
                }
            ]
        }
      '';
    };
}
