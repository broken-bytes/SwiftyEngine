import Core
import Foundation

public class Texture {

    internal let uuid: UUID
    
    public init(width: UInt16, height: UInt16, bytes: [UInt8]) {
        uuid = UUID()
    }

    public convenience init(width: UInt16, height: UInt16) {
        self.init(width: width, height: height, bytes: [])
    }

    public func pixelColor(x: UInt16, y: UInt16) -> Color {
        // TODO: Implement readback for certain textures
        return .red
    }
}