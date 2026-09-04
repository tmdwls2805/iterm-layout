import SwiftUI

@main
struct MyTermApp: App {
  var body: some Scene {
    WindowGroup("MyTerm") {
      ContentView()
        .frame(minWidth: 720, minHeight: 480)
    }
    .windowStyle(.hiddenTitleBar)
  }
}
