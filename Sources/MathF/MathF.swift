public func vectorAsMatrix(vector: Vector3) -> Matrix4x4 {
    var matrix = Matrix4x4()
    
    matrix.m00 = 1.0
    matrix.m11 = 1.0
    matrix.m22 = 1.0
    matrix.m33 = 1.0
    matrix.m30 = vector.x
    matrix.m31 = vector.y
    matrix.m33 = vector.z
    
    return matrix
}