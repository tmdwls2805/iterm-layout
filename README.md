# iterm-layout

iTerm2 창을 원하는 열/행 조합으로 자동 분할.

## 설치

```bash
git clone https://github.com/tmdwls2805/iterm-layout.git
cd iterm-layout
./install.sh
source ~/.zshrc
```

## 사용

```bash
layout 4 3    # 왼쪽 4행 · 오른쪽 3행
layout 3 3    # 왼쪽 3행 · 오른쪽 3행
layout 2 2    # 2x2
```

첫 인자 = 왼쪽 열 안 세션 수, 둘째 인자 = 오른쪽 열 안 세션 수.

## 요구사항

- macOS + iTerm2 (Preferences → General → Magic → **"Enable Python API"** or "AppleScript" 허용)
