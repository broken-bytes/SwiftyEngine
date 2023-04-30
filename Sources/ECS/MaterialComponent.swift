import Rendering

public struct MaterialComponent {

    internal var materialId: UInt64

    public init(with material: inout Material) {
        self.materialId = material.materialId
    }
}