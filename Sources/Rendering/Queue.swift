import Vulkan

class Queue {

    var vkQueue: UnsafeMutablePointer<VkQueue?>

    init(device: Device, familyIndex: UInt32) {
        vkQueue = .allocate(capacity: 1)
        vkGetDeviceQueue(device.device.pointee, familyIndex, 0, vkQueue)
    }
}