// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Nivelir",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "Nivelir",
            targets: ["Nivelir"]
        )
    ],
    targets: [
        .target(
            name: "Nivelir",
            path: "Sources"
        ),
        .testTarget(
            name: "NivelirTests",
            dependencies: ["Nivelir"],
            path: "Tests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
