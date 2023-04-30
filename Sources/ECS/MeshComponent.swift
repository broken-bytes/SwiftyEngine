import Rendering

public struct MeshComponent {

    internal var meshId: UInt64

    public init(with mesh: inout Mesh) {
        self.meshId = mesh.meshId
    }
}