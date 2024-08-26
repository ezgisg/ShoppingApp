// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Cart",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Cart",
            targets: ["Cart"]),
    ],
    dependencies: [
        .package(path: "../AppResources"),
        .package(path: "../AppManagers"),
        .package(path: "../Base"),
        .package(path: "../Network"),
        .package(path: "../Components"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Cart",
            dependencies: [
                "AppResources",
                "AppManagers",
                "Base",
                "Network",
                "Components",
            ]
        ),
        .testTarget(
            name: "CartTests",
            dependencies: ["Cart"]),
    ]
)
