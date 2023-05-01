import Vulkan

struct Fence {
    
    var vkFence: UnsafeMutablePointer<VkFence?>

    init(device: Device) {
        vkFence = .allocate(capacity: 1)
        var info = VkFenceCreateInfo()
        info.pNext = nil
        info.sType = VK_STRUCTURE_TYPE_FENCE_CREATE_INFO
        info.flags = UInt32(VK_FENCE_CREATE_SIGNALED_BIT.rawValue)

        vkHandleSafe(vkCreateFence(device.device.pointee, &info, nil, vkFence))
    }
}