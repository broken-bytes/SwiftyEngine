import Vulkan

struct Shader {

    let module: VkShaderModule

    init(module: VkShaderModule) {
        self.module = module
    }
}