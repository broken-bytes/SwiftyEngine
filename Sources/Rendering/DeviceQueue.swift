import Vulkan

class DeviceQueue {
    
    enum QueueType {
        case draw
        case copy
        case compute
    }

    init(type: QueueType) {
        var info = VkDeviceQueueCreateInfo()
        info.sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO
        //info.queueFamilyIndex = VK_QUEUEFAMILY
    }
}