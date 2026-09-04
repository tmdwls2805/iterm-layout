#!/usr/bin/env bash
# iterm-layout 을 ~/.zshrc 에 source. 이미 등록되어 있으면 스킵.
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"
LINE="source \"$DIR/layout.sh\""
if grep -Fq "$LINE" "$HOME/.zshrc" 2>/dev/null; then
  echo "이미 설치되어 있음."
else
  printf '\n%s\n' "$LINE" >> "$HOME/.zshrc"
  echo "설치 완료: $DIR/layout.sh"
fi
echo "→ 새 터미널을 열거나 'source ~/.zshrc' 후 'layout 4 3' 실행."
