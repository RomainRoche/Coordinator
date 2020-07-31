// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Coordinator",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(name: "Coordinator", type: .dynamic, targets: ["Coordinator"]),
    ],
    targets: [
        .target(
            name: "Coordinator",
            path: "Coordinator/"
        )
    ]
)
