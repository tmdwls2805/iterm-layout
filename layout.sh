# iterm-layout — iTerm2 자동 분할
# 사용: layout 4 3   (왼쪽 4행 · 오른쪽 3행)
#       layout 3 3
#       layout 2 2
layout() {
  local left=${1:-2}
  local right=${2:-2}
  osascript <<END
tell application "iTerm"
  activate
  set newWindow to (create window with default profile)
  tell current session of newWindow
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
