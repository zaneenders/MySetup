// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "MySetup",
    platforms: [
        .macOS("14.0"), .iOS("16.0"), .watchOS("9.0"), .tvOS("16.0"),
        .visionOS("1.0"),
    ],
    dependencies: [
        .package(
            url: "git@github.com:zaneenders/ScribeSystem.git",
            revision: "9d83daf")
        // .package(name: "ScribeSystem", path: "../ScribeSystem/"),
    ],
    targets: [
        .executableTarget(
            name: "Install",
            dependencies: [
                .product(name: "ScribeSystem", package: "ScribeSystem"),
                "NeoVim",
                "Alacritty",
                "Git",
                "SSH",
            ],
            resources: [
                .process("vscode/settings.json")
            ],
            swiftSettings: swiftSettings),
        .target(
            name: "Git",
            dependencies: [
                .product(name: "ScribeSystem", package: "ScribeSystem")
            ], swiftSettings: swiftSettings),
        .target(
            name: "SSH",
            dependencies: [
                .product(name: "ScribeSystem", package: "ScribeSystem")
            ], swiftSettings: swiftSettings),
        .target(
            name: "NeoVim",
            dependencies: [
                .product(name: "ScribeSystem", package: "ScribeSystem")
            ], swiftSettings: swiftSettings),
        .target(
            name: "Alacritty",
            dependencies: [
                .product(name: "ScribeSystem", package: "ScribeSystem")
            ], swiftSettings: swiftSettings),
    ]
)

// Swift 6 Settings
let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("BareSlashRegexLiterals"),
    .enableUpcomingFeature("ConciseMagicFile"),
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("ForwardTrailingClosures"),
    .enableUpcomingFeature("ImplicitOpenExistentials"),
    .enableUpcomingFeature("StrictConcurrency"),
    .unsafeFlags([
        "-warn-concurrency", "-enable-actor-data-race-checks",
    ]),
]
