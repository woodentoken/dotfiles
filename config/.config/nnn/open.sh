#!/bin/sh

case "$1" in
*.txt | *.md | *.py | *.c | *.cpp | *.h | *.json | *.toml | *.yaml | *.yml | *.sh | *.vim)
  nvim "$1"
  ;;
*)
  xdg-open "$1" >/dev/null 2>&1 &
  ;;
esac
