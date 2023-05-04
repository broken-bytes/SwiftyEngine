public struct Vector2 {
    
    public let x: Float
    public let y: Float

    public static var zero: Vector2 {
        Vector2(x: 0, y: 0)
    }

    public init(
        x: Float,
        y: Float
    ) {
        self.x = x
        self.y = y
    }
}

public struct Vector3 {
    
    public let x: Float
    public let y: Float
    public let z: Float

    public static var zero: Vector3 {
        Vector3(x: 0, y: 0, z: 0)
    }

    public init(
        x: Float,
        y: Float,
        z: Float
    ) {
        self.x = x
        self.y = y
        self.z = z
    }
}

public struct Vector4 {
    
    public let w: Float
    public let x: Float
    public let y: Float
    public let z: Float

    public static var zero: Vector4 {
        Vector4(w: 0, x: 0, y: 0, z: 0)
    }

    public init(
        w: Float,
        x: Float,
        y: Float,
        z: Float
    ) {
        self.w = w
        self.x = x
        self.y = y
        self.z = z
    }
}