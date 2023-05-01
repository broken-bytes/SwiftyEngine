import Core
import Vulkan

public protocol DrawCall {
    
    var key: UInt64 { get }
}

public struct ClearDrawCall: DrawCall {
    
    public let key: UInt64

    public init(
        fullscreen: UInt8, 
        viewportId: UInt8, 
        layer: UInt8, 
        clearColor: Color
    ) {
        key = 0
    }
}

public struct MeshDrawCall: DrawCall {
    
    public let key: UInt64
    public let meshId: UInt64!
    public let transform: Transform

    public init(
        fullscreen: UInt8, 
        viewportId: UInt8, 
        layer: UInt8, 
        translucency: UInt8, 
        materialId: UInt32, 
        depth: UInt32,
        meshId: UInt64,
        transform: Transform
    ) {
        key = 0
        self.meshId = meshId
        self.transform = transform
    }
}