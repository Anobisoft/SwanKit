// swift-tools-version: 6.2
//
//  Package.swift
//  SwanKit
//
//  Created by Stanislav Pletnev 2026-07-15.
//  Copyright © 2026 SwanKit. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "SwanKit",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16),
        .tvOS(.v16),
        .macOS(.v13),
        .watchOS(.v10)
    ],
    products: [
        .library(
            name: "SwanKit",
            targets: ["SwanKit"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwanKit",
            dependencies: [
                "SwanKitFoundation",
                .target(
                    name: "SwanKitUIExt",
                    condition: .when(platforms: [.iOS, .tvOS])
                )
            ],
            path: "SwanKit",
            exclude: [
                "Foundation",
                "UIExt"
            ]
        ),
        .target(
            name: "SwanKitFoundation",
            path: "SwanKit/Foundation"
        ),
        .target(
            name: "SwanKitUIExt",
            dependencies: ["SwanKitFoundation"],
            path: "SwanKit/UIExt"
        ),
        .testTarget(
            name: "SwanKitFoundationTests",
            dependencies: ["SwanKitFoundation"],
            path: "Tests/FoundationTests"
        )
    ]
)
