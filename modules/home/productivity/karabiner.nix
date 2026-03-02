{ ... }:
{
  flake.modules.homeManager.productivity =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ karabiner-elements ];

      xdg.configFile."karabiner/karabiner.json".text = ''
        {
            "profiles": [
                {
                    "complex_modifications": {
                        "rules": [
                            {
                                "description": "コマンドキーを単体で押したときに、英数・かなキーを送信する。（左コマンドキーは英数、右コマンドキーはかな） (rev 3)",
                                "enabled": false,
                                "manipulators": [
                                    {
                                        "from": {
                                            "key_code": "left_command",
                                            "modifiers": { "optional": ["any"] }
                                        },
                                        "parameters": { "basic.to_if_held_down_threshold_milliseconds": 100 },
                                        "to": [
                                            {
                                                "key_code": "left_command",
                                                "lazy": true
                                            }
                                        ],
                                        "to_if_alone": [{ "key_code": "japanese_eisuu" }],
                                        "to_if_held_down": [{ "key_code": "left_command" }],
                                        "type": "basic"
                                    },
                                    {
                                        "from": {
                                            "key_code": "right_command",
                                            "modifiers": { "optional": ["any"] }
                                        },
                                        "parameters": { "basic.to_if_held_down_threshold_milliseconds": 100 },
                                        "to": [
                                            {
                                                "key_code": "right_command",
                                                "lazy": true
                                            }
                                        ],
                                        "to_if_alone": [{ "key_code": "japanese_kana" }],
                                        "to_if_held_down": [{ "key_code": "right_command" }],
                                        "type": "basic"
                                    }
                                ]
                            },
                            {
                                "description": "CTRLキーを単体で押したときに、英数・かなキーを送信する。（左CTRLキーは英数、右CTRLキーはかな）",
                                "enabled": false,
                                "manipulators": [
                                    {
                                        "from": {
                                            "key_code": "left_control",
                                            "modifiers": { "optional": ["any"] }
                                        },
                                        "parameters": { "basic.to_if_held_down_threshold_milliseconds": 100 },
                                        "to": [
                                            {
                                                "key_code": "left_control",
                                                "lazy": true
                                            }
                                        ],
                                        "to_if_alone": [{ "key_code": "japanese_eisuu" }],
                                        "to_if_held_down": [{ "key_code": "left_control" }],
                                        "type": "basic"
                                    },
                                    {
                                        "from": {
                                            "key_code": "right_control",
                                            "modifiers": { "optional": ["any"] }
                                        },
                                        "parameters": { "basic.to_if_held_down_threshold_milliseconds": 100 },
                                        "to": [
                                            {
                                                "key_code": "right_control",
                                                "lazy": true
                                            }
                                        ],
                                        "to_if_alone": [{ "key_code": "japanese_kana" }],
                                        "to_if_held_down": [{ "key_code": "right_control" }],
                                        "type": "basic"
                                    }
                                ]
                            },
                            {
                                "description": "オプションキーを単体で押したときに、英数・かなキーを送信する。（左オプションキーは英数キー、右オプションキーはかなキー）",
                                "enabled": false,
                                "manipulators": [
                                    {
                                        "from": {
                                            "key_code": "left_option",
                                            "modifiers": { "optional": ["any"] }
                                        },
                                        "parameters": { "basic.to_if_held_down_threshold_milliseconds": 100 },
                                        "to": [
                                            {
                                                "key_code": "left_option",
                                                "lazy": true
                                            }
                                        ],
                                        "to_if_alone": [{ "key_code": "japanese_eisuu" }],
                                        "to_if_held_down": [{ "key_code": "left_option" }],
                                        "type": "basic"
                                    },
                                    {
                                        "from": {
                                            "key_code": "right_option",
                                            "modifiers": { "optional": ["any"] }
                                        },
                                        "parameters": { "basic.to_if_held_down_threshold_milliseconds": 100 },
                                        "to": [
                                            {
                                                "key_code": "right_option",
                                                "lazy": true
                                            }
                                        ],
                                        "to_if_alone": [{ "key_code": "japanese_kana" }],
                                        "to_if_held_down": [{ "key_code": "right_option" }],
                                        "type": "basic"
                                    }
                                ]
                            },
                            {
                                "description": "コマンドキー（左右どちらでも）を単体で押したときに、英数・かなをトグルで切り替える。 (rev 2)",
                                "enabled": false,
                                "manipulators": [
                                    {
                                        "conditions": [
                                            {
                                                "input_sources": [{ "language": "ja" }],
                                                "type": "input_source_if"
                                            }
                                        ],
                                        "from": {
                                            "key_code": "left_command",
                                            "modifiers": { "optional": ["any"] }
                                        },
                                        "parameters": { "basic.to_if_held_down_threshold_milliseconds": 100 },
                                        "to": [
                                            {
                                                "key_code": "left_command",
                                                "lazy": true
                                            }
                                        ],
                                        "to_if_alone": [{ "key_code": "japanese_eisuu" }],
                                        "to_if_held_down": [{ "key_code": "left_command" }],
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
                                            "key_code": "left_command",
                                            "modifiers": { "optional": ["any"] }
                                        },
                                        "parameters": { "basic.to_if_held_down_threshold_milliseconds": 100 },
                                        "to": [
                                            {
                                                "key_code": "left_command",
                                                "lazy": true
                                            }
                                        ],
                                        "to_if_alone": [{ "key_code": "japanese_kana" }],
                                        "to_if_held_down": [{ "key_code": "left_command" }],
                                        "type": "basic"
                                    },
                                    {
                                        "conditions": [
                                            {
                                                "input_sources": [{ "language": "ja" }],
                                                "type": "input_source_if"
                                            }
                                        ],
                                        "from": {
                                            "key_code": "right_command",
                                            "modifiers": { "optional": ["any"] }
                                        },
                                        "parameters": { "basic.to_if_held_down_threshold_milliseconds": 100 },
                                        "to": [
                                            {
                                                "key_code": "right_command",
                                                "lazy": true
                                            }
                                        ],
                                        "to_if_alone": [{ "key_code": "japanese_eisuu" }],
                                        "to_if_held_down": [{ "key_code": "right_command" }],
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
                                            "key_code": "right_command",
                                            "modifiers": { "optional": ["any"] }
                                        },
                                        "parameters": { "basic.to_if_held_down_threshold_milliseconds": 100 },
                                        "to": [
                                            {
                                                "key_code": "right_command",
                                                "lazy": true
                                            }
                                        ],
                                        "to_if_alone": [{ "key_code": "japanese_kana" }],
                                        "to_if_held_down": [{ "key_code": "right_command" }],
                                        "type": "basic"
                                    }
                                ]
                            },
                            {
                                "description": "右コマンドキーを、英数・かなのトグルに変更する",
                                "enabled": false,
                                "manipulators": [
                                    {
                                        "conditions": [
                                            {
                                                "input_sources": [{ "language": "ja" }],
                                                "type": "input_source_if"
                                            }
                                        ],
                                        "from": {
                                            "key_code": "right_command",
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
                                            "key_code": "right_command",
                                            "modifiers": { "optional": ["any"] }
                                        },
                                        "to": [{ "key_code": "japanese_kana" }],
                                        "type": "basic"
                                    }
                                ]
                            },
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
                                "description": "英数・かなキーを他のキーと同時に押したときに、Optionキーを送信する (rev 3)",
                                "enabled": false,
                                "manipulators": [
                                    {
                                        "from": {
                                            "key_code": "japanese_eisuu",
                                            "modifiers": { "optional": ["any"] }
                                        },
                                        "parameters": { "basic.to_if_alone_timeout_milliseconds": 200 },
                                        "to": [{ "key_code": "left_option" }],
                                        "to_if_alone": [{ "key_code": "japanese_eisuu" }],
                                        "type": "basic"
                                    },
                                    {
                                        "from": {
                                            "key_code": "japanese_kana",
                                            "modifiers": { "optional": ["any"] }
                                        },
                                        "parameters": { "basic.to_if_alone_timeout_milliseconds": 200 },
                                        "to": [{ "key_code": "right_option" }],
                                        "to_if_alone": [{ "key_code": "japanese_kana" }],
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
                            },
                            {
                                "description": "Ctrl+[を押したときに、英数キーも送信する（vim用） (rev 2)",
                                "enabled": false,
                                "manipulators": [
                                    {
                                        "conditions": [
                                            {
                                                "keyboard_types": ["ansi", "iso"],
                                                "type": "keyboard_type_if"
                                            }
                                        ],
                                        "from": {
                                            "key_code": "open_bracket",
                                            "modifiers": { "mandatory": ["control"] }
                                        },
                                        "to": [
                                            {
                                                "key_code": "open_bracket",
                                                "modifiers": ["control"]
                                            },
                                            { "key_code": "japanese_eisuu" }
                                        ],
                                        "type": "basic"
                                    },
                                    {
                                        "conditions": [
                                            {
                                                "keyboard_types": ["jis"],
                                                "type": "keyboard_type_if"
                                            }
                                        ],
                                        "from": {
                                            "key_code": "close_bracket",
                                            "modifiers": { "mandatory": ["control"] }
                                        },
                                        "to": [
                                            {
                                                "key_code": "close_bracket",
                                                "modifiers": ["control"]
                                            },
                                            { "key_code": "japanese_eisuu" }
                                        ],
                                        "type": "basic"
                                    }
                                ]
                            },
                            {
                                "description": "Ctrl+[を押したときに、escキーと英数キーを送信する",
                                "enabled": false,
                                "manipulators": [
                                    {
                                        "conditions": [
                                            {
                                                "keyboard_types": ["ansi", "iso"],
                                                "type": "keyboard_type_if"
                                            }
                                        ],
                                        "from": {
                                            "key_code": "open_bracket",
                                            "modifiers": { "mandatory": ["control"] }
                                        },
                                        "to": [
                                            { "key_code": "escape" },
                                            { "key_code": "japanese_eisuu" }
                                        ],
                                        "type": "basic"
                                    },
                                    {
                                        "conditions": [
                                            {
                                                "keyboard_types": ["jis"],
                                                "type": "keyboard_type_if"
                                            }
                                        ],
                                        "from": {
                                            "key_code": "close_bracket",
                                            "modifiers": { "mandatory": ["control"] }
                                        },
                                        "to": [
                                            { "key_code": "escape" },
                                            { "key_code": "japanese_eisuu" }
                                        ],
                                        "type": "basic"
                                    }
                                ]
                            },
                            {
                                "description": "英数・かなキーをtoggle方式にする",
                                "enabled": false,
                                "manipulators": [
                                    {
                                        "conditions": [
                                            {
                                                "input_sources": [{ "language": "ja" }],
                                                "type": "input_source_if"
                                            }
                                        ],
                                        "from": { "key_code": "japanese_kana" },
                                        "to": [{ "key_code": "japanese_eisuu" }],
                                        "type": "basic"
                                    },
                                    {
                                        "conditions": [
                                            {
                                                "input_sources": [{ "language": "ja" }],
                                                "type": "input_source_unless"
                                            }
                                        ],
                                        "from": { "key_code": "japanese_eisuu" },
                                        "to": [{ "key_code": "japanese_kana" }],
                                        "type": "basic"
                                    }
                                ]
                            },
                            {
                                "description": "右コマンドキーを単体で押したときに、かなキーを送信、左コントロールキーを単体で押したときに、英数キーを送信する。 (rev 2)",
                                "enabled": false,
                                "manipulators": [
                                    {
                                        "from": {
                                            "key_code": "left_control",
                                            "modifiers": { "optional": ["any"] }
                                        },
                                        "parameters": { "basic.to_if_held_down_threshold_milliseconds": 100 },
                                        "to": [
                                            {
                                                "key_code": "left_control",
                                                "lazy": true
                                            }
                                        ],
                                        "to_if_alone": [{ "key_code": "japanese_eisuu" }],
                                        "to_if_held_down": [{ "key_code": "left_control" }],
                                        "type": "basic"
                                    },
                                    {
                                        "from": {
                                            "key_code": "right_command",
                                            "modifiers": { "optional": ["any"] }
                                        },
                                        "parameters": { "basic.to_if_held_down_threshold_milliseconds": 100 },
                                        "to": [
                                            {
                                                "key_code": "right_command",
                                                "lazy": true
                                            }
                                        ],
                                        "to_if_alone": [{ "key_code": "japanese_kana" }],
                                        "to_if_held_down": [{ "key_code": "right_command" }],
                                        "type": "basic"
                                    }
                                ]
                            },
                            {
                                "description": "シフトキーを単体で押したときに、英数・かなキーを送信する。（左シフトキーは英数、右シフトキーはかな)",
                                "enabled": false,
                                "manipulators": [
                                    {
                                        "from": {
                                            "key_code": "left_shift",
                                            "modifiers": { "optional": ["any"] }
                                        },
                                        "parameters": { "basic.to_if_held_down_threshold_milliseconds": 100 },
                                        "to": [
                                            {
                                                "key_code": "left_shift",
                                                "lazy": true
                                            }
                                        ],
                                        "to_if_alone": [{ "key_code": "japanese_eisuu" }],
                                        "to_if_held_down": [{ "key_code": "left_shift" }],
                                        "type": "basic"
                                    },
                                    {
                                        "from": {
                                            "key_code": "right_shift",
                                            "modifiers": { "optional": ["any"] }
                                        },
                                        "parameters": { "basic.to_if_held_down_threshold_milliseconds": 100 },
                                        "to": [
                                            {
                                                "key_code": "right_shift",
                                                "lazy": true
                                            }
                                        ],
                                        "to_if_alone": [{ "key_code": "japanese_kana" }],
                                        "to_if_held_down": [{ "key_code": "right_shift" }],
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
