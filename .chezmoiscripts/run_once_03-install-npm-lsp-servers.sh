#!/bin/sh
# Install npm-based LSP servers not available in Mason
export npm_config_prefix="$HOME/.npm-global"
mkdir -p "$HOME/.npm-global/bin"

if ! [ -f "$HOME/.npm-global/bin/spyglassmc-language-server" ]; then
    echo "Installing @spyglassmc/language-server..."
    npm install -g @spyglassmc/language-server
fi

if ! [ -f "$HOME/.npm-global/bin/unocss-language-server" ]; then
    echo "Installing @unocss/language-server..."
    npm install -g unocss-language-server
fi
