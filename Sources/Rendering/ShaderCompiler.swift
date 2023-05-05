import Core
import Foundation
import Vulkan

enum ShaderError: Error {
    case shaderNotFound
    case shaderCompilationFailed
}

class ShaderCompiler {

    let device: Device

    init(device: Device) {
        self.device = device
    }

    func compile(at path: String) throws -> Shader {
        let fileUrl = URL(fileURLWithPath: path)
        guard let data = NSMutableData(contentsOf: fileUrl) else {
            throw ShaderError.shaderNotFound
        }

        var createInfo = VkShaderModuleCreateInfo(
            sType: VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO, 
            pNext: nil, 
            flags: 0, 
            codeSize: (data.length) + ((data.length) % 4), 
            pCode: data.bytes.assumingMemoryBound(to: UInt32.self)
        )

        var shaderModule: VkShaderModule?
        vkHandleSafe(vkCreateShaderModule(device.device, &createInfo, nil, &shaderModule))

        guard let shaderModule else {
            throw ShaderError.shaderCompilationFailed
        }

        return Shader(module: shaderModule, device: device)
    }
}