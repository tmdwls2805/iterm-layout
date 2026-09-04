import SwiftUI

struct ContentView: View {
  @State private var columns: [TerminalColumn] = [
    TerminalColumn(sessions: [TerminalSession()])
  ]

  var body: some View {
    HStack(spacing: 4) {
      ForEach($columns) { $column in
        VStack(spacing: 4) {
          ForEach($column.sessions) { $session in
            TerminalPane(session: $session)
              .background(Color.black)
          }
        }
      }
    }
    .padding(4)
    .background(Color.black)
    .onAppear {
      // 앱 실행 인자로 layout 지정 (예: "4,3") 시 자동 분할.
      let args = CommandLine.arguments
      if let idx = args.firstIndex(of: "--layout"), idx + 1 < args.count {
        setLayout(spec: args[idx + 1])
      }
    }
  }

  private func setLayout(spec: String) {
    let parts = spec.split(separator: ",").compactMap { Int($0) }
    guard !parts.isEmpty else { return }
    columns = parts.map { count in
      TerminalColumn(sessions: (0..<max(1, count)).map { _ in TerminalSession() })
    }
  }
}
