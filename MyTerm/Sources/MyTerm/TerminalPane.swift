import SwiftUI
import AppKit
import SwiftTerm
import UniformTypeIdentifiers

struct TerminalColumn: Identifiable {
  let id = UUID()
  var sessions: [TerminalSession]
}

struct TerminalSession: Identifiable {
  let id = UUID()
}

/// SwiftTerm 의 LocalProcessTerminalView 를 SwiftUI 로 감싼 뷰.
/// PTY 로 zsh 를 붙여 실제 터미널로 동작하고,
/// 텍스트 드롭을 받으면 그 문자열 + \n 을 세션에 write → 즉시 실행.
struct TerminalPane: View {
  @Binding var session: TerminalSession
  @State private var termHolder = TerminalHolder()

  var body: some View {
    TerminalHost(holder: termHolder)
      .background(Color.black)
      .onDrop(of: [UTType.plainText, UTType.utf8PlainText], isTargeted: nil) { providers in
        guard let provider = providers.first else { return false }
        _ = provider.loadObject(ofClass: NSString.self) { item, _ in
          guard let text = item as? String else { return }
          DispatchQueue.main.async {
            termHolder.send(text: text + "\n")
          }
        }
        return true
      }
  }
}

/// LocalProcessTerminalView 참조를 유지해 send 를 호출할 수 있게 한다.
final class TerminalHolder: ObservableObject {
  var view: LocalProcessTerminalView?

  func send(text: String) {
    guard let view else { return }
    let bytes = Array(text.utf8)
    // SwiftTerm 의 send API: [UInt8] slice 를 PTY 에 씀.
    view.send(data: bytes[...])
  }
}

/// NSViewRepresentable 로 실제 터미널 뷰 붙이기.
struct TerminalHost: NSViewRepresentable {
  let holder: TerminalHolder

  func makeNSView(context: Context) -> LocalProcessTerminalView {
    let view = LocalProcessTerminalView(frame: .zero)
    let shell = ProcessInfo.processInfo.environment["SHELL"] ?? "/bin/zsh"
    view.startProcess(executable: shell, args: [], environment: nil, execName: nil)
    holder.view = view
    return view
  }

  func updateNSView(_ nsView: LocalProcessTerminalView, context: Context) {}
}
