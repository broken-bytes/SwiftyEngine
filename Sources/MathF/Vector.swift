import Foundation

public struct Vector2 {
    
    public var x: Float
    public var y: Float

    public static var zero: Vector2 {
        Vector2(x: 0, y: 0)
    }

    public static var one: Vector2 {
        Vector2(x: 1, y: 1)
    }

    public init(
        x: Float,
        y: Float
    ) {
        self.x = x
        self.y = y
    }

    public static func +(lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    public static func -(lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}

public struct Vector3 {
    
    public var x: Float
    public var y: Float
    public var z: Float

    public static var zero: Vector3 {
        Vector3(x: 0, y: 0, z: 0)
    }

    public static var one: Vector3 {
        Vector3(x: 1, y: 1, z: 1)
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

    public static func +(lhs: Vector3, rhs: Vector3) -> Vector3 {
        return Vector3(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }

    public static func -(lhs: Vector3, rhs: Vector3) -> Vector3 {
        return Vector3(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }
}

public struct Vector4 {
    
    public var x: Float
    public var y: Float
    public var z: Float
    public var w: Float

    public static var zero: Vector4 {
        Vector4(x: 0, y: 0, z: 0, w: 0)
    }

    public static var one: Vector4 {
        Vector4(x: 1, y: 1, z: 1, w: 1)
    }

    public init(
        x: Float,
        y: Float,
        z: Float,
        w: Float
    ) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
}

public func normalize(_ vector: Vector3) -> Vector3 {
    let length = sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z)
    return Vector3(x: vector.x / length, y: vector.y / length, z: vector.z / length)
}

public func cross(_ a: Vector3, _ b: Vector3) -> Vector3 {
    let x = a.y * b.z - a.z * b.y
    let y = a.z * b.x - a.x * b.z
    let z = a.x * b.y - a.y * b.x
    return Vector3(x: x, y: y, z: z)
}

public func dot(_ a: Vector3, _ b: Vector3) -> Float {
    return a.x * b.x + a.y * b.y + a.z * b.z
}