// swift-tools-version:5.8
import PackageDescription

let package = Package(
    name: "SpotifySpatialAudio",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.77.1"),
    ],
    targets: [
        .executableTarget(
            name: "SpotifySpatialAudio",
            dependencies: [
                .product(name: "Vapor", package: "vapor")
            ]
        )
    ]
)
