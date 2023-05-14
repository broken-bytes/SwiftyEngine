import Foundation
import FreeImage

public class Texture {

    public let width: UInt32
    public let height: UInt32
    var data: UnsafeMutableRawPointer
    
    public init(width: UInt32, height: UInt32, bytes: UnsafeMutableRawPointer) {
        self.width = width
        self.height = height
        self.data = bytes
    }

    deinit {

    }

    public func pixelColor(x: UInt32, y: UInt32) -> Color {
        // TODO: Implement readback for certain textures
        return .red
    }
}