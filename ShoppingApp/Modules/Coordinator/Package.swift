// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Coordinator",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Coordinator",
            targets: ["Coordinator"]),
    ],
    dependencies: [
        .package(path: "../Base"),
        .package(path: "../ProductList"),
        .package(path: "../Favorites"),
        .package(path: "../Campaigns"),
        .package(path: "../Cart"),
        .package(path: "../Home"),
        .package(path: "../TabBar"),
        .package(path: "../Categories"),
        .package(path: "../Splash"),
        .package(path: "../Onboarding"),
        .package(path: "../SignIn")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Coordinator",
            dependencies: [
                "Base",
                "ProductList",
                "Favorites",
                "Campaigns",
                "Cart",
                "Home",
                "TabBar",
                "Categories",
                "Splash",
                "Onboarding",
                "SignIn",
            ]
        ),
        .testTarget(
            name: "CoordinatorTests",
            dependencies: ["Coordinator"]),
    ]
)
