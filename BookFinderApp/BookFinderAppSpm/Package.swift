// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BookFinderAppSpm",
    platforms: [
        .iOS(.v15), .macOS(.v12)
    ],
    products: [
        .library(
            name: "BookFinderAppSpm",
            targets: ["BookFinderAppSpm"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git",  .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols.git", .upToNextMajor(from: "4.1.0")),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.7.0")),
        .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git", .upToNextMajor(from: "2.0.0")),
    ],
    targets: [
        .target(
            name: "BookFinderAppSpm",
            dependencies: [
                "SwiftyJSON",
                "SFSafeSymbols",
                "Alamofire",
                "SDWebImageSwiftUI",
            ]
        ),
        .testTarget(
            name: "BookFinderAppSpmTests",
            dependencies: ["BookFinderAppSpm"]),
    ]
)
