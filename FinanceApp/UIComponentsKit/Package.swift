// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "UIComponentsKit",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "UIComponentsKit",
            targets: ["UIComponentsKit"]),
    ],
    targets: [
        .target(
            name: "UIComponentsKit",
            dependencies: [])
    ]
)
