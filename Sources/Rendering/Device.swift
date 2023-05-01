import DXC
import SDL
import Vulkan

class Device {

    internal var device: UnsafeMutablePointer<VkDevice?>
    internal var physicalDevice: VkPhysicalDevice

    init(physicalDevice: VkPhysicalDevice, name: String) {
        var count: UInt32 = 0
        vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice, &count, nil)
        var props: UnsafeMutablePointer<VkQueueFamilyProperties> = .allocate(capacity: Int(count))
        vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice, &count, props)

        var prios: [Float] = [1.0]

        var qInfo = VkDeviceQueueCreateInfo()

        var enabledExtensions: [UnsafePointer<Int8>?] = []
        VK_KHR_SWAPCHAIN_EXTENSION_NAME.withCString {
            enabledExtensions.append($0)
        }

        prios.withUnsafeBufferPointer {
            qInfo.pQueuePriorities = $0.baseAddress
        }
        qInfo.sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO
        qInfo.pNext = nil
        qInfo.queueCount = props.pointee.queueCount
        qInfo.queueFamilyIndex = 0
        var info = VkDeviceCreateInfo()
        info.sType = VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO
        info.enabledExtensionCount = 1
        info.enabledLayerCount = 0
        enabledExtensions.withUnsafeBufferPointer {
            info.ppEnabledExtensionNames = $0.baseAddress!
        }
        
        info.ppEnabledLayerNames = nil
        info.queueCreateInfoCount = 1
        withUnsafePointer(to: &qInfo) {
            info.pQueueCreateInfos = $0
        }

        device = .allocate(capacity: 1)

        vkHandleSafe(vkCreateDevice(physicalDevice, &info, nil, device))
        self.physicalDevice = physicalDevice
    }

    func compileShader(shader: String) {
    }
}