import DXC
import SDL
import Vulkan

enum MemoryError: Error {
    case noSuitableMemoryType
}

class Device {

    internal var device: VkDevice?
    internal var physicalDevice: VkPhysicalDevice

    init(physicalDevice: VkPhysicalDevice, name: String) {
        var count: UInt32 = 0
        vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice, &count, nil)
        var props: UnsafeMutablePointer<VkQueueFamilyProperties> = .allocate(capacity: Int(count))
        vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice, &count, props)

        let prios: UnsafeMutablePointer<Float> = .allocate(capacity: 1)
        prios.initialize(to: 1)

        var qInfo: UnsafeMutablePointer<VkDeviceQueueCreateInfo> = .allocate(capacity: 1)
        qInfo.initialize(to: VkDeviceQueueCreateInfo(
            sType: VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO, 
            pNext: nil, 
            flags: 0, 
            queueFamilyIndex: 0, 
            queueCount: 1, 
            pQueuePriorities: prios
        ))

        let enabledExtensions: UnsafeMutablePointer<UnsafePointer<Int8>?> = .allocate(capacity: 1)

        VK_KHR_SWAPCHAIN_EXTENSION_NAME.withCString {
            enabledExtensions.initialize(to: $0)
        }

        var info = VkDeviceCreateInfo(
            sType: VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO, 
            pNext: nil, 
            flags: 0, 
            queueCreateInfoCount: 1, 
            pQueueCreateInfos: qInfo, 
            enabledLayerCount: 0, 
            ppEnabledLayerNames: nil, 
            enabledExtensionCount: 1, 
            ppEnabledExtensionNames: enabledExtensions, 
            pEnabledFeatures: nil
        )

        vkHandleSafe(vkCreateDevice(physicalDevice, &info, nil, &device))
        self.physicalDevice = physicalDevice

        defer { 
            prios.deallocate()
            enabledExtensions.deallocate()
            props.deallocate()
        }
    }

    deinit {
        vkDestroyDevice(device, nil)
    }

    func createVertexBuffer(with vertices: [Vertex]) -> VertexBuffer {
        VertexBuffer(device: self, with: vertices)
    }

    func createIndexBuffer(with indices: [UInt32]) -> IndexBuffer {
        IndexBuffer(device: self, with: indices)
    }
}
