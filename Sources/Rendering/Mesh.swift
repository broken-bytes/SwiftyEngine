import Core
import Foundation

public struct Mesh: Identifiable {
    public typealias ID = UInt32
    private static var meshIds: [UInt32] = []

    public let id: ID
    internal let vertexBuffer: VertexBuffer
    internal let indexBuffer: IndexBuffer

    internal init(vertexBuffer: VertexBuffer, indexBuffer: IndexBuffer) {
        self.id = Mesh.meshIds.nextFreeValue
        self.vertexBuffer = vertexBuffer
        self.indexBuffer = indexBuffer
    }
}