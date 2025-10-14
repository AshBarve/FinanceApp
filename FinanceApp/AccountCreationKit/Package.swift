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
        .package(path: "../UIComponentsKit"),
        .package(url: "https://github.com/jdg/MBProgressHUD.git", from: "1.2.0")
    ],
    targets: [
        .target(
            name: "AccountCreationKit",
            dependencies: [
                "UIComponentsKit",
                "MBProgressHUD"
            ])
    ]
)
