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
            name: "ObjCDump"
        ),
        .testTarget(
            name: "ObjCDumpTests",
            dependencies: ["ObjCDump"]
        ),
    ]
)
