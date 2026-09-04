# iterm-layout — iTerm2 자동 분할
# 사용:
#   layout            → GUI 프롬프트 (열/행/새창vs기존창 선택)
#   layout 4 3        → 왼쪽 4행 · 오른쪽 3행 (새 창)
#   layout 4 3 same   → 왼쪽 4행 · 오른쪽 3행 (현재 창에서 분할)
layout() {
  local left="$1"
  local right="$2"
  local target="${3:-new}"   # new | same

  # 인자 없으면 GUI 로 물어보기 (AppleScript dialog).
  if [ -z "$left" ] || [ -z "$right" ]; then
    local reply
    reply=$(osascript <<'END'
try
  set dims to text returned of (display dialog "몇 대 몇으로 나눌까요? (예: 4 3)" default answer "4 3" with title "iterm-layout")
  set targetChoice to button returned of (display dialog "어디에 만들까요?" buttons {"취소", "현재 창", "새 창"} default button "새 창" with title "iterm-layout")
  return dims & "|" & targetChoice
on error
  return "CANCEL"
end try
END
)
    [ "$reply" = "CANCEL" ] && return 0
    local dims="${reply%|*}"
    local choice="${reply##*|}"
    left="${dims%% *}"
    right="${dims##* }"
    if [ "$choice" = "현재 창" ]; then
      target="same"
    else
      target="new"
    fi
  fi

  # 숫자 유효성 최소 방어.
  case "$left$right" in
    ''|*[!0-9]*) echo "layout: 숫자 두 개가 필요합니다 (예: layout 4 3)"; return 1 ;;
  esac

  local windowExpr
  if [ "$target" = "same" ]; then
    windowExpr='set win to current window'
  else
    windowExpr='set win to (create window with default profile)'
  fi

  osascript <<END
tell application "iTerm"
  activate
  $windowExpr
  tell current session of win
    repeat $((left - 1)) times
      split horizontally with default profile
    end repeat
    set rightPane to split vertically with default profile
  end tell
  tell rightPane
    repeat $((right - 1)) times
      split horizontally with default profile
    end repeat
  end tell
end tell
END
}
