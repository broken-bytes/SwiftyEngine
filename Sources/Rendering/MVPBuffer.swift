import MathF

struct MVPBuffer: Codable {
    
    var model: Matrix4x4
    var projection: Matrix4x4
    var view: Matrix4x4
}