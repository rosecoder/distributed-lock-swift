// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "distributed-lock",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .library(name: "DistributedLock", targets: ["DistributedLock"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.2"),
        .package(url: "https://github.com/apple/swift-distributed-tracing.git", from: "1.1.0"),
    ],
    targets: [
        .target(
            name: "DistributedLock",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Tracing", package: "swift-distributed-tracing"),
            ]
        ),
    ]
)
