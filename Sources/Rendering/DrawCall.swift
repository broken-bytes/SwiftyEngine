import Core

public struct DrawCall {
    internal let key: UInt64
    internal let meshId: UInt64!
    internal let transform: Transform

    public init(
        fullscreen: UInt8, 
        viewportId: UInt8, 
        layer: UInt8, 
        transluceny: UInt8, 
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