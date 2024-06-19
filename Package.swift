// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "ObjCDump",
    products: [
        .library(
            name: "ObjCDump",
            targets: ["ObjCDump"]
        ),
    ],
    targets: [
        .target(
            name: "ObjCDump",
            dependencies: [
                "ObjCTypeDecodeKit"
            ]
        ),
        .target(
            name: "ObjCTypeDecodeKit"
        ),
        .testTarget(
            name: "ObjCDumpTests",
            dependencies: ["ObjCDump"]
        ),
        .testTarget(
            name: "ObjCTypeDecodeKitTests",
            dependencies: ["ObjCTypeDecodeKit"]
        ),
    ]
)
