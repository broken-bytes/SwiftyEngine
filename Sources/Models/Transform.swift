import MathF

public struct Transform {
    public var position: Vector3
    public var rotation: Quaternion
    public var scale: Vector3

    public init(
        position: Vector3,
        rotation: Quaternion,
        scale: Vector3
    ) {
        self.position = position
        self.rotation = rotation
        self.scale = scale
    }
}