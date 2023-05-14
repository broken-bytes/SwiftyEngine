import Vulkan

class CommandPool {

    var vkCommandPool: VkCommandPool?
    var device: Device

    init(device: Device, familyIndex: UInt32) {
        self.device = device

        var info = VkCommandPoolCreateInfo()
        info.sType = VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO
        info.queueFamilyIndex = familyIndex
        info.flags = UInt32(VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT.rawValue)
        vkHandleSafe(vkCreateCommandPool(device.device, &info, nil, &vkCommandPool))
    }

    func reset() {
        vkResetCommandPool(device.device, vkCommandPool, 0)
    }

    deinit {
        vkDestroyCommandPool(device.device, vkCommandPool, nil)
    }
}