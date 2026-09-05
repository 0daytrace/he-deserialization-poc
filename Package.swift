// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "HE_PoC",
    platforms: [.macOS(.v26)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-homomorphic-encryption", branch: "main")
    ],
    targets: [
        .executableTarget(
            name: "HE_PoC",
            dependencies: [
                .product(name: "HomomorphicEncryption", package: "swift-homomorphic-encryption")
            ]
        )
    ]
)
