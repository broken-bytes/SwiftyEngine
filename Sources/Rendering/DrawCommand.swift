public struct DrawCommand {
    internal let key: UInt64 

    public init(fullscreen: UInt8, viewportId: UInt8, layer: UInt8, command: UInt16, data: UInt64) {
        key = 0
    }
}