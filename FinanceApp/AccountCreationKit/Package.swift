// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AccountCreationKit",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "AccountCreationKit",
            targets: ["AccountCreationKit"]),
    ],
    dependencies: [
        .package(path: "../UIComponentsKit")
    ],
    targets: [
        .target(
            name: "AccountCreationKit",
            dependencies: ["UIComponentsKit"])
    ]
)
