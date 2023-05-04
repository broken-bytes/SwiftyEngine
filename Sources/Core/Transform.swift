public struct Transform {
    public var position: Vector3
    public var rotation: Vector4
    public var scale: Vector3

    public init(
        position: Vector3,
        rotation: Vector4,
        scale: Vector3
    ) {
        self.position = position
        self.rotation = rotation
        self.scale = scale
    }
}