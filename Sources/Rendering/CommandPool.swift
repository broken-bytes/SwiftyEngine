import Vulkan

class CommandPool {

    var vkCommandPool: UnsafeMutablePointer<VkCommandPool?>

    init(device: Device, familyIndex: UInt32) {
        vkCommandPool = .allocate(capacity: 1)

        var info = VkCommandPoolCreateInfo()
        info.sType = VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO
        info.queueFamilyIndex = familyIndex
        info.flags = UInt32(VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT.rawValue)
        vkHandleSafe(vkCreateCommandPool(device.device.pointee, &info, nil, vkCommandPool))
    }
}