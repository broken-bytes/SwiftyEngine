public struct Quaternion {

    public var x: Float
    public var y: Float
    public var z: Float
    public var w: Float

    public static var identity: Quaternion {
        Quaternion(x: 0, y: 0, z: 0, w: 1)
    }

    public init() {
        x = 0
        y = 0
        z = 0
        w = 0
    }

    public init(x: Float, y: Float, z: Float, w: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }

    public static func+(lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        Quaternion(
            x: lhs.x + rhs.x, 
            y: lhs.y + rhs.y, 
            z: lhs.z + rhs.z, 
            w: lhs.w + rhs.w
        )
    }
}