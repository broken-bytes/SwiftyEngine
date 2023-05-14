import Foundation

public struct Matrix {

    private var columns: Int
    private var rows: Int

    var values: [Float]

    public init(columns: Int, rows: Int) {
        precondition(columns > 0)
        precondition(rows > 0)

        self.columns = columns
        self.rows = rows

        values = .init(repeating: 0, count: columns * rows)
    }

    public subscript(row: Int, column: Int) -> Float {
        get { 
            values[(columns * row) + column] 
        } 
        set { 
            values[columns * row + column] = newValue 
        } 
    }
}

public struct Matrix4x4 {

    public var m00: Float
    public var m01: Float
    public var m02: Float
    public var m03: Float
    public var m10: Float
    public var m11: Float
    public var m12: Float
    public var m13: Float
    public var m20: Float
    public var m21: Float
    public var m22: Float
    public var m23: Float
    public var m30: Float
    public var m31: Float
    public var m32: Float
    public var m33: Float

    public init() {
        m00 = 0
        m01 = 0
        m02 = 0
        m03 = 0
        m10 = 0
        m11 = 0
        m12 = 0
        m13 = 0
        m20 = 0
        m21 = 0
        m22 = 0
        m23 = 0
        m30 = 0
        m31 = 0
        m32 = 0
        m33 = 0
    }
}

// MARK: Free Matrix Functions

public func perspectiveFovLH(fov: Float, aspect: Float, nearDist: Float, farDist: Float) -> Matrix4x4 {
    fovMatrix(fov: fov, aspect: aspect, nearDist: nearDist, farDist: farDist, leftHanded: true)
}

public func perspectiveFovRH(fov: Float, aspect: Float, nearDist: Float, farDist: Float) -> Matrix4x4 {
    fovMatrix(fov: fov, aspect: aspect, nearDist: nearDist, farDist: farDist, leftHanded: false)
}

private func fovMatrix(fov: Float, aspect: Float, nearDist: Float, farDist: Float, leftHanded: Bool) -> Matrix4x4 {
    if fov <= 0 || aspect == 0
    {
        fatalError("Neither fov or aspect may be 0.")
    }

    var result = Matrix4x4()

    let frustumDepth = farDist - nearDist
    let oneOverDepth = 1 / frustumDepth

    result.m11 = 1 / tan(0.5 * fov)
    result.m00 = (leftHanded ? 1 : -1 ) * result.m11 / aspect
    result.m22 = farDist * oneOverDepth
    result.m32 = (-farDist * nearDist) * oneOverDepth
    result.m23 = 1
    result.m33 = 0

    return result
}

public func lookAtLH(eye: Vector3, target: Vector3) -> Matrix4x4 {
    lookAt(eye: eye, target: target, isLeftHanded: true)
}

public func lookAtRH(eye: Vector3, target: Vector3) -> Matrix4x4 {
    lookAt(eye: eye, target: target, isLeftHanded: false)
}

private func lookAt(eye: Vector3, target: Vector3, isLeftHanded: Bool) -> Matrix4x4 {    
    var matrix = Matrix4x4()
    let zAxis = normalize(eye - target)
    let xAxis = normalize(cross(Vector3(x: 0, y: 1, z: 0), zAxis))
    let yAxis = cross(zAxis, xAxis)
    
    if isLeftHanded {
        matrix.m00 = xAxis.x
        matrix.m01 = xAxis.y
        matrix.m02 = xAxis.z
        matrix.m10 = yAxis.x
        matrix.m11 = yAxis.y
        matrix.m12 = yAxis.z
        matrix.m20 = zAxis.x
        matrix.m21 = zAxis.y
        matrix.m22 = zAxis.z
    } else {
        matrix.m00 = -xAxis.x
        matrix.m01 = -xAxis.y
        matrix.m02 = -xAxis.z
        matrix.m10 = -yAxis.x
        matrix.m11 = -yAxis.y
        matrix.m12 = -yAxis.z
        matrix.m20 = -zAxis.x
        matrix.m21 = -zAxis.y
        matrix.m22 = -zAxis.z
    }
    
    matrix.m30 = -dot(xAxis, eye)
    matrix.m31 = -dot(yAxis, eye)
    matrix.m32 = -dot(zAxis, eye)
    matrix.m33 = 1.0
    
    return matrix
}