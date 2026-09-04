import SwiftUI

struct ContentView: View {
  @State private var store = CommandStore()
  @State private var columns: [TerminalColumn] = [
    TerminalColumn(sessions: [TerminalSession()])
  ]

  var body: some View {
    HStack(spacing: 0) {
      CommandListView(store: store)
        .frame(width: 260)

      Divider()

      HStack(spacing: 4) {
        ForEach($columns) { $column in
          VStack(spacing: 4) {
            ForEach($column.sessions) { $session in
              TerminalPane(session: $session)
            }
          }
        }
      }
      .padding(4)
      .background(Color.black)
    }
    .onAppear {
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
