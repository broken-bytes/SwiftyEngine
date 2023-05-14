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

public struct Matrix4x4: Codable {

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
        m00 = 1
        m01 = 0
        m02 = 0
        m03 = 0
        m10 = 0
        m11 = 1
        m12 = 0
        m13 = 0
        m20 = 0
        m21 = 0
        m22 = 1
        m23 = 0
        m30 = 0
        m31 = 0
        m32 = 0
        m33 = 1
    }

    internal init(
        m00: Float, m01: Float, m02: Float, m03: Float,
        m10: Float, m11: Float, m12: Float, m13: Float,
        m20: Float, m21: Float, m22: Float, m23: Float,
        m30: Float, m31: Float, m32: Float, m33: Float
    ) {
        self.m00 = m00
        self.m01 = m01
        self.m02 = m02
        self.m03 = m03
        self.m10 = m10
        self.m11 = m11
        self.m12 = m12
        self.m13 = m13
        self.m20 = m20
        self.m21 = m21
        self.m22 = m22
        self.m23 = m23
        self.m30 = m30
        self.m31 = m31
        self.m32 = m32
        self.m33 = m33
    }

    public subscript(column: Int, row: Int) -> Float {
        get {
            switch (column, row) {
            case (0, 0):
                return m00
            case (1, 0):
                return m01
            case (2, 0):
                return m02
            case (3, 0):
                return m03
            case (0, 1):
                return m10
            case (1, 1):
                return m11
            case (2, 1):
                return m12
            case (3, 1):
                return m13
            case (0, 2):
                return m20
            case (1, 2):
                return m21
            case (2, 2):
                return m22
            case (3, 2):
                return m23
            case (0, 3):
                return m30
            case (1, 3):
                return m31
            case (2, 3):
                return m32
            case (3, 3):
                return m33
            default:
                fatalError("Invalid matrix index")
            }
        }
        set {
            switch (column, row) {
            case (0, 0):
                m00 = newValue
            case (1, 0):
                m01 = newValue
            case (2, 0):
                m02 = newValue
            case (3, 0):
                m03 = newValue
            case (0, 1):
                m10 = newValue
            case (1, 1):
                m11 = newValue
            case (2, 1):
                m12 = newValue
            case (3, 1):
                m13 = newValue
            case (0, 2):
                m20 = newValue
            case (1, 2):
                m21 = newValue
            case (2, 2):
                m22 = newValue
            case (3, 2):
                m23 = newValue
            case (0, 3):
                m30 = newValue
            case (1, 3):
                m31 = newValue
            case (2, 3):
                m32 = newValue
            case (3, 3):
                m33 = newValue
            default:
                fatalError("Invalid matrix index")
            }
        }
    }

    public mutating func scale(vector: Vector3) {
        m00 *= vector.x
        m01 *= vector.x
        m02 *= vector.x
        m03 *= vector.x
        m10 *= vector.y
        m11 *= vector.y
        m12 *= vector.y
        m13 *= vector.y
        m20 *= vector.z
        m21 *= vector.z
        m22 *= vector.z
        m23 *= vector.z
    }

    public mutating func translate(vector: Vector3) {
        m03 += vector.x
        m13 += vector.y
        m23 += vector.z
    }

    public mutating func rotate(angle: Float, axis: Vector3) {
        let normalizedAxis = normalize(axis)
        let cosAngle = cos(angle)
        let sinAngle = sin(angle)
        let oneMinusCosAngle = 1 - cosAngle
        
        let x = normalizedAxis.x
        let y = normalizedAxis.y
        let z = normalizedAxis.z
        
        let xx = x * x
        let xy = x * y
        let xz = x * z
        let yy = y * y
        let yz = y * z
        let zz = z * z
        
        let xyOneMinusCos = xy * oneMinusCosAngle
        let xzOneMinusCos = xz * oneMinusCosAngle
        let yzOneMinusCos = yz * oneMinusCosAngle
        
        let xsin = x * sinAngle
        let ysin = y * sinAngle
        let zsin = z * sinAngle
        
        var rotationMatrix = Matrix4x4()
        
        rotationMatrix.m00 = xx * oneMinusCosAngle + cosAngle
        rotationMatrix.m01 = xyOneMinusCos - zsin
        rotationMatrix.m02 = xzOneMinusCos + ysin
        
        rotationMatrix.m10 = xyOneMinusCos + zsin
        rotationMatrix.m11 = yy * oneMinusCosAngle + cosAngle
        rotationMatrix.m12 = yzOneMinusCos - xsin
        
        rotationMatrix.m20 = xzOneMinusCos - ysin
        rotationMatrix.m21 = yzOneMinusCos + xsin
        rotationMatrix.m22 = zz * oneMinusCosAngle + cosAngle
        
        self = self * rotationMatrix
    }

    public mutating func rotate(quaternion: Quaternion) {
        let qv = Vector3(x: quaternion.x, y: quaternion.y, z: quaternion.z)
        let qw = quaternion.w
        
        let xx = qv.x * qv.x
        let xy = qv.x * qv.y
        let xz = qv.x * qv.z
        let xw = qv.x * qw
        
        let yy = qv.y * qv.y
        let yz = qv.y * qv.z
        let yw = qv.y * qw
        
        let zz = qv.z * qv.z
        let zw = qv.z * qw
        
        let rotationMatrix = Matrix4x4(
            m00: 1 - 2 * (yy + zz), m01: 2 * (xy - zw), m02: 2 * (xz + yw), m03: 0,
            m10: 2 * (xy + zw), m11: 1 - 2 * (xx + zz), m12: 2 * (yz - xw), m13: 0,
            m20: 2 * (xz - yw), m21: 2 * (yz + xw), m22: 1 - 2 * (xx + yy), m23: 0,
            m30: 0, m31: 0, m32: 0, m33: 1
        )
        
        self = rotationMatrix * self
    }

    public static func *(lhs: Matrix4x4, rhs: Matrix4x4) -> Matrix4x4 {
        var result = Matrix4x4()
        
        result.m00 = lhs.m00 * rhs.m00 + lhs.m01 * rhs.m10 + lhs.m02 * rhs.m20 + lhs.m03 * rhs.m30
        result.m01 = lhs.m00 * rhs.m01 + lhs.m01 * rhs.m11 + lhs.m02 * rhs.m21 + lhs.m03 * rhs.m31
        result.m02 = lhs.m00 * rhs.m02 + lhs.m01 * rhs.m12 + lhs.m02 * rhs.m22 + lhs.m03 * rhs.m32
        result.m03 = lhs.m00 * rhs.m03 + lhs.m01 * rhs.m13 + lhs.m02 * rhs.m23 + lhs.m03 * rhs.m33
        
        result.m10 = lhs.m10 * rhs.m00 + lhs.m11 * rhs.m10 + lhs.m12 * rhs.m20 + lhs.m13 * rhs.m30
        result.m11 = lhs.m10 * rhs.m01 + lhs.m11 * rhs.m11 + lhs.m12 * rhs.m21 + lhs.m13 * rhs.m31
        result.m12 = lhs.m10 * rhs.m02 + lhs.m11 * rhs.m12 + lhs.m12 * rhs.m22 + lhs.m13 * rhs.m32
        result.m13 = lhs.m10 * rhs.m03 + lhs.m11 * rhs.m13 + lhs.m12 * rhs.m23 + lhs.m13 * rhs.m33
        
        result.m20 = lhs.m20 * rhs.m00 + lhs.m21 * rhs.m10 + lhs.m22 * rhs.m20 + lhs.m23 * rhs.m30
        result.m21 = lhs.m20 * rhs.m01 + lhs.m21 * rhs.m11 + lhs.m22 * rhs.m21 + lhs.m23 * rhs.m31
        result.m22 = lhs.m20 * rhs.m02 + lhs.m21 * rhs.m12 + lhs.m22 * rhs.m22 + lhs.m23 * rhs.m32
        result.m23 = lhs.m20 * rhs.m03 + lhs.m21 * rhs.m13 + lhs.m22 * rhs.m23 + lhs.m23 * rhs.m33
        
        result.m30 = lhs.m30 * rhs.m00 + lhs.m31 * rhs.m10 + lhs.m32 * rhs.m20 + lhs.m33 * rhs.m30
        result.m31 = lhs.m30 * rhs.m01 + lhs.m31 * rhs.m11 + lhs.m32 * rhs.m21 + lhs.m33 * rhs.m31
        result.m32 = lhs.m30 * rhs.m02 + lhs.m31 * rhs.m12 + lhs.m32 * rhs.m22 + lhs.m33 * rhs.m32
        result.m33 = lhs.m30 * rhs.m03 + lhs.m31 * rhs.m13 + lhs.m32 * rhs.m23 + lhs.m33 * rhs.m33
        
        return result
    }

    public mutating func transpose() {
        self = Matrix4x4(
            m00: m00, m01: m10, m02: m20, m03: m30, 
            m10: m01, m11: m11, m12: m21, m13: m31, 
            m20: m02, m21: m12, m22: m22, m23: m32, 
            m30: m03, m31: m13, m32: m23, m33: m33
        )
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

    result.m11 = 1 / tan(0.5 * fov * .pi / 180)
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