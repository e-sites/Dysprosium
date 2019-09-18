// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Dysprosium",
    platforms: [
        .iOS(.v8),
    ],
    products: [
        .library(name: "Dysprosium", targets: ["Dysprosium"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Dysprosium",
            dependencies: [],
            path: "Sources"
        )
    ]
)
