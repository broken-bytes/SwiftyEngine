import Core
import Foundation
import Models
import Vulkan

public protocol DrawCall {
    
    // Fullscreen: 0 
    // ViewportID: 1-3
    // Layer: 4-7
    // Command or Draw Flag: 8
    // 9-63 Based on DrawCall type
    var key: UInt64 { get }
}

extension DrawCall {
    var isFullscreenEffect: Bool {
        return (0x0000000000000001 & key == 1)
    }

    var viewPortId: UInt8 {
        return UInt8(0x0000000000000000F & (key >> 1))
    }

    var layer: UInt8 {
        return UInt8(0x0000000000000000F & (key >> 4))
    }

    var isCommand: Bool { 
        return (0x0000000000010000 & key == 256)
    }
}

public struct ClearDrawCall: DrawCall {
    
    // Fullscreen: 0 
    // ViewportID: 1-3
    // Layer: 4-7
    // Command or Draw Flag: 8 = 0
    // 9-63 Based on DrawCall type
    public let key: UInt64

    public init(
        fullscreen: Bool, 
        viewportId: UInt8, 
        layer: UInt8, 
        clearColor: Color
    ) {
        key = 0
    }
}

public struct MeshDrawCall: DrawCall {
    
    // Fullscreen: 0 
    // ViewportID: 1-3
    // Layer: 4-7
    // Command or Draw Flag: 8 = 1
    // 9-15: Transluceny
    // 16-47: Material ID
    // 48 - 63 depth
    public let key: UInt64
    public let meshId: UInt32
    public let transform: Transform

    var materialId: Int32 {
        return Int32((0x000000000FFFFFFFF & (key >> 16)))
    }

    public init(
        viewportId: UInt8, 
        layer: UInt8, 
        translucency: UInt8, 
        materialId: UInt32, 
        depth: UInt16,
        meshId: UInt32,
        transform: Transform
    ) {
        var newKey: UInt64 = 0
        newKey += 0b100000000
        newKey += (UInt64(materialId) << 16)
        newKey += (UInt64(1) << 2)
        self.key = newKey
        self.meshId = meshId
        self.transform = transform
    }
}