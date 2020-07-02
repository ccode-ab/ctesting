// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "CTesting",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(name: "CTesting", targets: ["CTesting"]),
    ],
    dependencies: [
        .package(name: "SnapshotTesting", url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.8.1"),
    ],
    targets: [
        .target(name: "CTesting", dependencies: ["SnapshotTesting"]),
    ]
)
