// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "MyTerm",
  platforms: [.macOS(.v14)],
  products: [
    .executable(name: "MyTerm", targets: ["MyTerm"]),
  ],
  dependencies: [
    // SwiftTerm — 터미널 뷰 + PTY + VT/ANSI 에뮬레이션.
    .package(url: "https://github.com/migueldeicaza/SwiftTerm.git", from: "1.2.0"),
  ],
  targets: [
    .executableTarget(
      name: "MyTerm",
      dependencies: [
        .product(name: "SwiftTerm", package: "SwiftTerm"),
      ],
      path: "Sources/MyTerm"
    ),
  ]
)
