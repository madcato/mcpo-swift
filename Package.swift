// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "mcpo-swift",
    platforms: [
        // Add support for all platforms starting from a specific version.
        .macOS(.v12),
        .iOS(.v13),
        .watchOS(.v9),
        .tvOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "mcpo-swift",
            targets: ["mcpo-swift"]),
    ],
    dependencies: [
        .package(url: "https://github.com/MacPaw/OpenAI.git", branch: "main"),
        .package(url: "https://github.com/apple/swift-log", from: "1.6.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "mcpo-swift",
            dependencies: [
                .product(name: "OpenAI", package: "OpenAI"),
                .product(name: "Logging", package: "swift-log"),
            ]),
        .testTarget(
            name: "mcpo-swiftTests",
            dependencies: ["mcpo-swift"]
        ),
    ]
)
