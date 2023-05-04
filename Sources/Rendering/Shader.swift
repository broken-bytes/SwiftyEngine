import Core
import Foundation
import Vulkan

public class Shader: Identifiable {
    public typealias ID = UInt32

    private static var shaderIds: [UInt32] = []

    public let id: ID
    let module: VkShaderModule
    let device: Device

    init(module: VkShaderModule, device: Device) {
        id = Shader.shaderIds.nextFreeValue
        self.module = module
        self.device = device
    }

    deinit {
        vkDestroyShaderModule(device.device, module, nil)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func ==(lhs: Shader, rhs: Shader) -> Bool {
        lhs.id == rhs.id
    }
}