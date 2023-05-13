// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Packages",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "DartModels",
            targets: ["DartModels"]),
        .library(
            name: "CricketGame",
            targets: ["CricketGame"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DartModels",
            dependencies: [],
            path: "Sources/DartModels"),
        .target(
            name: "CricketGame",
            dependencies: ["DartModels"],
            path: "Sources/CricketGame"),
    ]
)
