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
  # 1) 몇 대 몇 입력 → 2) 미리보기(번호 매긴 텍스트 아트) → 3) 새 창/현재 창.
  if [ -z "$left" ] || [ -z "$right" ]; then
    local dims
    dims=$(osascript <<'END'
try
  return text returned of (display dialog "몇 대 몇으로 나눌까요? (예: 4 3)" default answer "4 3" with title "iterm-layout")
on error
  return "CANCEL"
end try
END
)
    [ "$dims" = "CANCEL" ] && return 0
    left="${dims%% *}"
    right="${dims##* }"

    # 미리보기(번호 매김) 생성. 왼쪽 열은 1..left, 오른쪽 열은 left+1..left+right.
    local preview=""
    local rows=$left
    [ "$right" -gt "$rows" ] && rows=$right
    local i n_left n_right leftCell rightCell
    for ((i = 1; i <= rows; i++)); do
      if [ "$i" -le "$left" ]; then
        n_left=$i
        leftCell=$(printf "[ %2d ]" "$n_left")
      else
        leftCell="      "
      fi
      if [ "$i" -le "$right" ]; then
        n_right=$((left + i))
        rightCell=$(printf "[ %2d ]" "$n_right")
      else
        rightCell="      "
      fi
      preview+="${leftCell}  ${rightCell}"$'\n'
    done

    local choice
    choice=$(osascript <<END
try
  return button returned of (display dialog "${left} × ${right} 로 만듭니다.

${preview}
어디에 만들까요?" buttons {"취소", "현재 창", "새 창"} default button "새 창" with title "iterm-layout")
on error
  return "CANCEL"
end try
END
)
    [ "$choice" = "CANCEL" ] && return 0
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

  # 생성 후에도 확인할 수 있도록 미리보기 재생성 (인자 모드로 호출된 경우 대비).
  local previewAfter=""
  local afterRows=$left
  [ "$right" -gt "$afterRows" ] && afterRows=$right
  local ii lc rc
  for ((ii = 1; ii <= afterRows; ii++)); do
    if [ "$ii" -le "$left" ]; then
      lc=$(printf "[ %2d ]" "$ii")
    else
      lc="      "
    fi
    if [ "$ii" -le "$right" ]; then
      rc=$(printf "[ %2d ]" "$((left + ii))")
    else
      rc="      "
    fi
    previewAfter+="${lc}  ${rc}"$'\n'
  done

  osascript <<END
tell application "iTerm"
  activate
  $windowExpr
  set leftSessions to {current session of win}
  -- 1) 좌·우 두 열로 나눔. 오른쪽 열 첫 세션 저장.
  tell current session of win
    set rightTop to split vertically with default profile
  end tell
  set rightSessions to {rightTop}
  -- 2) 왼쪽 열(첫 세션) 을 (left - 1) 번 가로 분할, 각 결과 세션을 리스트에 append.
  set leftCurrent to current session of win
  repeat $((left - 1)) times
    tell leftCurrent
      set nextS to split horizontally with default profile
    end tell
    set end of leftSessions to nextS
    set leftCurrent to nextS
  end repeat
  -- 3) 오른쪽 열 을 (right - 1) 번 가로 분할, 각 결과 세션 append.
  set rightCurrent to rightTop
  repeat $((right - 1)) times
    tell rightCurrent
      set nextS to split horizontally with default profile
    end tell
    set end of rightSessions to nextS
    set rightCurrent to nextS
  end repeat
  -- 4) 이름 부여: 왼쪽 1..left, 오른쪽 left+1..left+right.
  repeat with i from 1 to (count of leftSessions)
    set name of item i of leftSessions to ("" & i)
  end repeat
  repeat with i from 1 to (count of rightSessions)
    set name of item i of rightSessions to ("" & (${left} + i))
  end repeat
end tell
END

  # 생성 결과 미리보기 팝업 (닫기 전엔 유지).
  osascript <<END &
display dialog "생성 완료: ${left} × ${right}

${previewAfter}" buttons {"닫기"} default button "닫기" with title "iterm-layout"
END
}
