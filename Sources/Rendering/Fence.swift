import Vulkan

struct Fence {
    
    var vkFence: VkFence?
    var device: Device

    init(device: Device, startSignaled: Bool = true) {
        var info = VkFenceCreateInfo()
        info.pNext = nil
        info.sType = VK_STRUCTURE_TYPE_FENCE_CREATE_INFO
        info.flags = UInt32(startSignaled ? VK_FENCE_CREATE_SIGNALED_BIT.rawValue : 0)
        self.device = device
        vkHandleSafe(vkCreateFence(device.device, &info, nil, &vkFence))
    }

    func wait() {
        withUnsafePointer(to: vkFence) {
            vkHandleSafe(vkWaitForFences(device.device, 1, $0, VK_TRUE, 1000000000))
        }
    }

    func reset() {
        withUnsafePointer(to: vkFence) {
       	    vkHandleSafe(vkResetFences(device.device, 1, $0))
        }
    }
}