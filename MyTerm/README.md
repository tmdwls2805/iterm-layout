# MyTerm

SwiftUI + [SwiftTerm](https://github.com/migueldeicaza/SwiftTerm) 으로 만든 미니 터미널 앱.
`layout` 스크립트에서 호출해 원하는 분할(예: 4,3)로 자체 창을 띄우는 것이 목적.

## 요구사항

- macOS 13+ / Swift 5.9+ (Xcode 15 권장)

## 빌드 & 실행

```bash
cd MyTerm
swift run -c release             # 기본 1x1
swift run -c release -- --layout 4,3   # 왼쪽 4행, 오른쪽 3행
swift run -c release -- --layout 3,3,2 # 3열: 3행 / 3행 / 2행
```

## 구조

- `Package.swift` — SwiftTerm 의존성
- `Sources/MyTerm/MyTermApp.swift` — 앱 진입점
- `Sources/MyTerm/ContentView.swift` — 컬럼×행 그리드
- `Sources/MyTerm/TerminalPane.swift` — SwiftTerm 어댑터 (PTY + zsh)
