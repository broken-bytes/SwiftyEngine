import Vulkan

struct Semaphore {

    var vkSemaphore: UnsafeMutablePointer<VkSemaphore?>

    init(device: Device) {
        vkSemaphore = .allocate(capacity: 1)

        var info = VkSemaphoreCreateInfo()
        info.sType = VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO
        info.pNext = nil

        vkHandleSafe(vkCreateSemaphore(device.device.pointee, &info, nil, vkSemaphore))
    }
}