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
        .package(url: "https://github.com/onevcat/Kingfisher.git", exact: "8.9.0"),
        .package(url: "https://github.com/airbnb/lottie-spm.git", exact: "4.6.0"),
        .package(url: "https://github.com/exyte/SVGView.git", exact: "1.0.6"),
        .package(url: "https://github.com/exyte/PopupView.git", exact: "5.0.1"),
        .package(url: "https://github.com/dewangga18/OwlNav.git", exact: "0.0.5"),
        .package(url: "https://github.com/realm/realm-swift.git", exact: "20.0.4"),
        .package(url: "https://github.com/Swinject/Swinject.git", exact: "2.10.0")
    ],
    targets: [
        .target(
            name: "CoreSPM",
            dependencies: [
                .product(name: "Kingfisher", package: "Kingfisher"),
                .product(name: "Lottie", package: "lottie-spm"),
                .product(name: "SVGView", package: "SVGView"),
                .product(name: "PopupView", package: "PopupView"),
                .product(name: "OwlNav", package: "OwlNav"),
                .product(name: "RealmSwift", package: "realm-swift"),
                .product(name: "Swinject", package: "Swinject")
            ],
        ),
    ]
)
