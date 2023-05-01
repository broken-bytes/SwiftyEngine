import Vulkan

class Queue {

    var vkQueue: VkQueue?

    init(device: Device, familyIndex: UInt32) {
        vkGetDeviceQueue(device.device.pointee, familyIndex, 0, &vkQueue)
    }
}