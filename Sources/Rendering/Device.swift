import SDL
import Vulkan

class Device {

    init(physicalDevice: VkPhysicalDevice, name: String) {
        var info = VkDeviceCreateInfo()
        info.sType = VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO
    }
}