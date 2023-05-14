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
            targets: ["TestApp", "GameKit"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/broken-bytes/SwiftyGLTF.git", from: "1.0.1")
    ],
    targets: [
        .executableTarget(
            name: "TestApp",
            dependencies: ["GameKit"],
            linkerSettings: [
                .unsafeFlags(["-I", "H:/Projects/SwiftTest/.build/x86_64-unknown-windows-msvc/debug"]),
                .unsafeFlags(["-L", "H:/Projects/SwiftTest/.build/x86_64-unknown-windows-msvc/debug"]),
                .unsafeFlags(["-l", "H:/Projects/SwiftTest/.build/x86_64-unknown-windows-msvc/debug/Assembly"])
            ]
        ),
        .target(
            name: "Audio",
            dependencies: ["Core", "MathF", "Models", "OpenAL", "SDL"],
            path: "Sources/Audio",
            linkerSettings: [
                .unsafeFlags(["-L", "E:/libs/OpenAL/libs/Win64"]),
                .unsafeFlags(["-L", "E:/libs/SDL/lib/x64"]),
                .unsafeFlags(["-l", "OpenAL32.lib"]),
                .unsafeFlags(["-l", "SDL2.lib"]),
            ]
        ),
        .target(
            name: "Core",
            dependencies: ["Flecs", "MathF", "SDL"],
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
            dependencies: ["Audio", "Core", "ECS", "IO", "Rendering", "MathF", "Models"],
            path: "Sources/GameKit"
        ),
        .target(
            name: "IO",
            dependencies: ["Core", "Models", .product(name: "SwiftyGLTF", package: "SwiftyGLTF")],
            path: "Sources/IO"
        ),
        .target(
            name: "MathF",
            dependencies: []
        ),
        .target(
            name: "Models",
            dependencies: ["MathF"],
            path: "Sources/Models"
        ),
        .target(
            name: "Rendering",
            dependencies: ["Core", "FreeImage", "MathF", "Models", "SDL", "Vulkan"],
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
                .unsafeFlags(["-L", "E:/libs/FreeImage/Dist/x64"]),
                .unsafeFlags(["-l", "FreeImage"]),
            ]
        ),
        .target(
            name: "Flecs",
            path: "Sources/Vendor/Flecs"
        ),
        .target(
            name: "FreeImage",
            path: "Sources/Vendor/FreeImage"
        ),
        .target(
            name: "OpenAL",
            path: "Sources/Vendor/OpenAL"
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