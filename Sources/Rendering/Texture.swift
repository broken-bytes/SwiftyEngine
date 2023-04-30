import Core

public class Texture {

    internal let textureId: UInt64
    
    public init(width: UInt16, height: UInt16, bytes: [UInt8]) {
        self.textureId = 0
    }

    public convenience init(width: UInt16, height: UInt16) {
        self.init(width: width, height: height, bytes: [])
    }

    public func pixelColor(x: UInt16, y: UInt16) -> Color {
        return .red
    }
}