// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DevTools",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DevTools",
            targets: ["DevTools"]),
    ],
//    dependencies: [
//        .package(url: "https://github.com/realm/SwiftLint", .upToNextMajor(from: .init(0, 0, 0)))
//    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DevTools"
//            plugins: [
//                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
//            ]
        ),
        .testTarget(
            name: "DevToolsTests",
            dependencies: ["DevTools"])
    ]
)
