import MathF

public struct Vertex {

    public let position: Vector3
    public let uv: Vector2
    public let color: Color

    public init(
        position: Vector3,
        uv: Vector2,
        color: Color
    ) {
        self.position = position
        self.uv = uv
        self.color = color
    }
}