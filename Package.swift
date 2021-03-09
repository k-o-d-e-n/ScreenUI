// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "ScreenUI",
    products: [
        .library(name: "ScreenUI", targets: ["ScreenUI"])
    ],
    dependencies: [],
    targets: [
        .target(name: "ScreenUI", dependencies: []),
        .testTarget(name: "ScreenUITests", dependencies: ["ScreenUI"])
    ]
)
