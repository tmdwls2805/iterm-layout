# iterm-layout — iTerm2 자동 분할
# 사용:
#   layout            → GUI 프롬프트 ("4x3" 형식 한 번에 입력)
#   layout 4 3        → 왼쪽 4행 · 오른쪽 3행 (새 창)
layout() {
  local left="$1"
  local right="$2"

  # 인자 없으면 GUI 로 하나의 입력창에서 "4 3" or "4x3" 받기.
  if [ -z "$left" ] || [ -z "$right" ]; then
    local dims
    dims=$(osascript <<'END'
try
  return text returned of (display dialog "몇 대 몇으로 나눌까요? (예: 4x3 또는 4 3)" default answer "4x3" with title "iterm-layout")
on error
  return "CANCEL"
end try
END
)
    [ "$dims" = "CANCEL" ] && return 0
    dims=$(printf '%s' "$dims" | tr 'xX×,' ' ' | tr -s ' ')
    left="${dims%% *}"
    right="${dims##* }"
    case "$left$right" in
      ''|*[!0-9]*|0*|*0)
        osascript -e 'display dialog "1 이상의 숫자 두 개를 입력하세요 (예: 4x3)" buttons {"확인"} default button "확인" with title "iterm-layout"' >/dev/null 2>&1
        return 1
        ;;
    esac
  fi

  case "$left$right" in
    ''|*[!0-9]*) echo "layout: 숫자 두 개가 필요합니다 (예: layout 4 3)"; return 1 ;;
  esac

  osascript <<END
tell application "iTerm"
  activate
  set win to (create window with default profile)
  set leftSessions to {current session of win}
  tell current session of win
    set rightTop to split vertically with default profile
  end tell
  set rightSessions to {rightTop}
  set leftCurrent to current session of win
  repeat $((left - 1)) times
    tell leftCurrent
      set nextS to split horizontally with default profile
    end tell
    set end of leftSessions to nextS
    set leftCurrent to nextS
  end repeat
  set rightCurrent to rightTop
  repeat $((right - 1)) times
    tell rightCurrent
      set nextS to split horizontally with default profile
    end tell
    set end of rightSessions to nextS
    set rightCurrent to nextS
  end repeat
  repeat with i from 1 to (count of leftSessions)
    set name of item i of leftSessions to ("" & i)
  end repeat
  repeat with i from 1 to (count of rightSessions)
    set name of item i of rightSessions to ("" & (${left} + i))
  end repeat
end tell
END
}
