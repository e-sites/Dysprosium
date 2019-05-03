// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Dysprosium",
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
