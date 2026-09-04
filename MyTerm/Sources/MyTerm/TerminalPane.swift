import SwiftUI
import AppKit
import SwiftTerm

struct TerminalColumn: Identifiable {
  let id = UUID()
  var sessions: [TerminalSession]
}

struct TerminalSession: Identifiable {
  let id = UUID()
}

/// SwiftTerm 의 LocalProcessTerminalView 를 SwiftUI 로 감싸는 어댑터.
/// PTY 로 zsh 프로세스를 붙여 실제 터미널로 동작.
struct TerminalPane: NSViewRepresentable {
  @Binding var session: TerminalSession

  func makeNSView(context: Context) -> LocalProcessTerminalView {
    let view = LocalProcessTerminalView(frame: .zero)
    let shell = ProcessInfo.processInfo.environment["SHELL"] ?? "/bin/zsh"
    view.startProcess(executable: shell, args: [], environment: nil, execName: nil)
    return view
  }

  func updateNSView(_ nsView: LocalProcessTerminalView, context: Context) {}
}
