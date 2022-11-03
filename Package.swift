// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Nivelir",
    platforms: [
        .iOS(.v12),
        .tvOS(.v12)
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
