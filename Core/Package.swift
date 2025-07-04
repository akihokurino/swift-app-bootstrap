// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.iOS(.v18)],
    products: [
        .library(name: "Feature", targets: ["Feature"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.20.2"),
        .package(url: "https://github.com/apollographql/apollo-ios.git", from: "1.23.0"),
        .package(url: "https://github.com/exyte/ActivityIndicatorView.git", from: "1.1.1"),
        .package(url: "https://github.com/kean/Nuke.git", from: "12.7.2"),
    ],
    targets: [
        .target(name: "Feature", dependencies: [
            .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            .product(name: "Apollo", package: "apollo-ios"),
            "ActivityIndicatorView",
            "Nuke",
        ]),
    ]
)
