// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CoreSPM",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(
            name: "CoreSPM",
            targets: ["CoreSPM"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/dewangga18/OwlNav.git", exact: "0.0.5"),
    ],
    targets: [
        .target(
            name: "CoreSPM",
            dependencies: [
                .product(name: "OwlNav", package: "OwlNav"),
            ]
        ),
    ]
)
