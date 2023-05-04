import Foundation

public struct MeshData {
    
    let vertices: [Vertex]
    let indices: [UInt32]

    public init(vertices: [Vertex], indices: [UInt32]) {
        self.vertices = vertices
        self.indices = indices
    }
}