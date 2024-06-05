// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Services",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Services",
            targets: ["Services"]),
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher", exact: "7.11.0")
    ],
    targets: [
        .target(
            name: "Services",
            dependencies: [
                .product(name: "Kingfisher", package: "Kingfisher")
            ]
        ),
    ]
)
