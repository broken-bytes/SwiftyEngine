// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name: "GameKit",
    products: [
        .library(
            name: "GameKit",
            type: .dynamic,
            targets: ["GameKit"]
        ),
        .library(
            name: "Assembly",
            type: .dynamic,
            targets: ["Assembly"]
        ),
        .executable(
            name: "TestApp", 
            targets: ["TestApp"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .executableTarget(
            name: "TestApp",
            linkerSettings: [
                .unsafeFlags(["-I", "H:/Projects/SwiftTest/.build/x86_64-unknown-windows-msvc/debug"]),
                .unsafeFlags(["-L", "H:/Projects/SwiftTest/.build/x86_64-unknown-windows-msvc/debug"]),
                .unsafeFlags(["-l", "H:/Projects/SwiftTest/.build/x86_64-unknown-windows-msvc/debug/Assembly"])
            ]
        ),
        .target(
            name: "Core",
            dependencies: ["Flecs", "SDL"],
            path: "Sources/Core",
            linkerSettings: [
                .unsafeFlags(["-L", "E:/libs/SDL/lib/x64"]),
                .unsafeFlags(["-l", "SDL2.lib"]),
                .unsafeFlags(["-l", "SDL2main.lib"]),
            ]
        ),
        .target(
            name: "ECS",
            dependencies: ["Flecs", "Rendering"],
            path: "Sources/ECS"
        ),
        .target(
            name: "GameKit",
            dependencies: ["Core", "ECS", "Rendering"],
            path: "Sources/GameKit"
        ),
        .target(
            name: "Rendering",
            dependencies: ["Core", "SDL", "Vulkan"],
            path: "Sources/Rendering",
            swiftSettings: [
                .unsafeFlags(["-emit-module"]),
            ],
            linkerSettings: [
                .unsafeFlags(["-L", "E:/libs/Vulkan/Lib"]),
                .unsafeFlags(["-l", "vulkan-1.lib"]),
                .unsafeFlags(["-L", "E:/libs/SDL/lib/x64"]),
                .unsafeFlags(["-l", "SDL2.lib"]),
                .unsafeFlags(["-l", "SDL2main.lib"]),
            ]
        ),
        .target(
            name: "Flecs",
            path: "Sources/Vendor/Flecs"
        ),
        .target(
            name: "SDL",
            path: "Sources/Vendor/SDL"
        ),
        .target(
            name: "Vulkan",
            path: "Sources/Vendor/Vulkan",
            swiftSettings: [
                .unsafeFlags(["-D", "VK_USE_PLATFORM_WIN32_KHR"])
            ]
        ),
        .target(
            name: "Assembly",
            linkerSettings: [
                .unsafeFlags(["-L", "H:/Projects/SwiftTest/.build/x86_64-unknown-windows-msvc/debug"]),
                .unsafeFlags(["-I", "H:/Projects/SwiftTest/.build/x86_64-unknown-windows-msvc/debug"]),
                .unsafeFlags(["-l", "GameKit"]),
            ]
        )
    ]
)