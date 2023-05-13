// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "BuildTools",
    platforms: [.macOS(.v10_11)],
    dependencies: [
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.51.9"),
    ],
    targets: [.target(name: "BuildTools", path: "")]
)
