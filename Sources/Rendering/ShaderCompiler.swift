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
        guard let fileUrl = URL(string: path) else {
            throw ShaderError.shaderNotFound
        }
        do {
            let data = try String(contentsOf: fileUrl)
            var createInfo = VkShaderModuleCreateInfo()
            createInfo.sType = VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO
            createInfo.pNext = nil
            
            data.withCString {
                createInfo.codeSize = strlen($0) / 4 
                createInfo.pCode = UnsafeRawPointer($0).assumingMemoryBound(to: UInt32.self)
            }

            var shaderModule: VkShaderModule?
            vkHandleSafe(vkCreateShaderModule(device.device.pointee, &createInfo, nil, &shaderModule))

            guard let shaderModule else {
                throw ShaderError.shaderCompilationFailed
            }
            
            return Shader(module: shaderModule)

        } catch {
            throw ShaderError.shaderNotFound
        }
    }
}