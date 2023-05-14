import Foundation

public struct MeshData {
    
    public let vertices: [Vertex]
    public let indices: [UInt16]

    public init(vertices: [Vertex], indices: [UInt16]) {
        self.vertices = vertices
        self.indices = indices
    }
}