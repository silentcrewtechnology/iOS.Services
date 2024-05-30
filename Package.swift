// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Services",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Services",
            targets: ["Services"]),
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher", exact: "7.11.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", exact: "5.6.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Services",
            dependencies: [
                .product(name: "Kingfisher", package: "Kingfisher"),
                .product(name: "SnapKit", package: "SnapKit")
            ]
        ),
        .testTarget(
            name: "ServicesTests",
            dependencies: ["Services"]),
    ]
)
