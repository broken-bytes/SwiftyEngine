import Core
import Foundation

public class Material: Hashable {

    private static var materialIds: [UInt32] = []

    internal let id: UInt32
    internal var vertexShader: Shader
    internal var pixelShader: Shader
    internal var pipeline: Pipeline

    internal var textures: [String: UUID] = [:]

    internal init(vertexShader: Shader, pixelShader: Shader, pipeline: Pipeline) {
        self.id = Material.materialIds.nextFreeValue
        self.vertexShader = vertexShader
        self.pixelShader = pixelShader
        self.pipeline = pipeline
    }

    public func setTexture(key: String, value: Texture) {
        textures[key] = value.uuid
    }

    public func setColor(key: String, value: Color) {

    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(vertexShader.id)
        hasher.combine(pixelShader.id)
        hasher.combine(id)
    }

    public static func == (lhs: Material, rhs: Material) -> Bool { lhs.id == rhs.id }
}