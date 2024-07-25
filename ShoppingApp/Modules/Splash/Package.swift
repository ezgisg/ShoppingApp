// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Splash",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Splash",
            targets: ["Splash"]),
    ],
    dependencies: [
        .package(path: "../AppResources"),
        .package(url: "https://github.com/airbnb/lottie-spm.git", .upToNextMajor(from: "4.5.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Splash",
            dependencies: [
                .product(name: "Lottie", package: "lottie-spm"),
                "AppResources",
            ]),
        .testTarget(
            name: "SplashTests",
            dependencies: ["Splash"]),
    ]
)



