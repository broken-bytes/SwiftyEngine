import Vulkan

struct Semaphore {

    var vkSemaphore: VkSemaphore?

    init(device: Device) {

        var info = VkSemaphoreCreateInfo()
        info.sType = VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO
        info.pNext = nil

        vkHandleSafe(vkCreateSemaphore(device.device.pointee, &info, nil, &vkSemaphore))
    }

    func wait() {

    }
}