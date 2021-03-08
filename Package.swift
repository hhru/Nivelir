// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Nivelir",
    platforms: [
        .iOS(.v10),
        .tvOS(.v10)
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
