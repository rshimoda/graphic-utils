// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GraphicUtils",
    products: [
        .library(
            name: "ColorUtils",
            targets: ["ColorUtils"]
        )
    ],
    targets: [
        .target(
            name: "ColorUtils",
            path: "Sources/ColorUtils"
        ),
        .executableTarget(
            name: "ColorUtilsWASM",
            dependencies: ["ColorUtils"],
            path: "Sources/ColorUtilsWASM"
        ),
    ]
)
