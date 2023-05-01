import Vulkan

class Shader {

    let module: VkShaderModule
    let device: Device

    init(module: VkShaderModule, device: Device) {
        self.module = module
        self.device = device
    }

    deinit {
        vkDestroyShaderModule(device.device, module, nil)
    }
}