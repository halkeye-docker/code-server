#!/bin/bash

. /asdf/asdf.sh

test -f "$HOME/.asdfrc" || echo 'legacy_version_file = yes' > "$HOME/.asdfrc"
test -f "$HOME/.default-npm-packages" || printf 'yarn\njsonlint\nserve\npm-check-updates\n' > "$HOME/.default-npm-packages"
test -f "$HOME/.default-gems" || printf 'solargraph\nbundler\npry\n' > "$HOME/.default-gems"

chown -R $(id -u abc):$(id -g abc) /asdf

exec /init "$@"
