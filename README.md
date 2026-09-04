# iterm-layout

iTerm2 창을 원하는 열/행 조합으로 자동 분할.

## 목표

매일 사용하는 긴 커맨드를 매번 치기 귀찮을 때, 저장해두고
원하는 iTerm 창에서 톡톡 눌러 실행할 수 있게 한다.
긴 커맨드를 외워서 다시 치지 않도록 하는 것이 목적.

## 설치

```bash
git clone https://github.com/tmdwls2805/iterm-layout.git
cd iterm-layout
./install.sh
source ~/.zshrc
```

## 사용

### GUI 모드 (인자 없이)
```bash
layout
```
- "몇 대 몇으로 나눌까요?" 다이얼로그에 `4 3` 같이 입력
- "새 창" / "현재 창" 선택

### CLI 모드
```bash
layout 4 3          # 새 창에 왼쪽 4행 · 오른쪽 3행
layout 4 3 same     # 현재 창에서 그대로 분할
layout 3 3
layout 2 2
```

첫 인자 = 왼쪽 열 안 세션 수, 둘째 인자 = 오른쪽 열 안 세션 수,
셋째 인자(옵션) = `new`(기본) 또는 `same`.

## 요구사항

- macOS + iTerm2 (Preferences → General → Magic → **"Enable Python API"** or "AppleScript" 허용)
