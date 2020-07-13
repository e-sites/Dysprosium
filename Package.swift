// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Dysprosium",
    platforms: [
        .iOS(.v10),
    ],
    products: [
        .library(name: "Dysprosium", targets: ["Dysprosium"]),
        .library(name: "DysprosiumLog", targets: ["DysprosiumLog"])
    ],
    dependencies: [
      .package(url: "https://github.com/e-sites/lithium.git", from: "9.0.0")
    ],
    targets: [
        .target(
            name: "Dysprosium",
            dependencies: [],
            path: "Sources/Core"
        ),

        .target(
            name: "DysprosiumLog",
            dependencies: [ "Dysprosium", "Lithium" ],
            path: "Sources/Logging"
        )
    ]
)
