import Vulkan

// MARK: Helpers for Memory
enum MemoryHelpers {
    static func findMemoryType(device: Device, for filter: UInt32, and properties: VkMemoryPropertyFlags) throws -> UInt32 {
        var memProperties = VkPhysicalDeviceMemoryProperties()
        vkGetPhysicalDeviceMemoryProperties(device.physicalDevice, &memProperties)
        for x in 0..<memProperties.memoryTypeCount {
            if ((filter & (1 << x) > 0) && (try! memProperties.memoryType(at: x).propertyFlags & properties) == properties) {
                return x
            }
        }

        throw MemoryError.noSuitableMemoryType
    }
}

// MARK: Extension for types that are badly bridged
fileprivate extension VkPhysicalDeviceMemoryProperties {
    
    func memoryType(at: UInt32) throws -> VkMemoryType {
        switch at {
            case 0:
            return self.memoryTypes.0
            case 1:
            return self.memoryTypes.1
            case 2:
            return self.memoryTypes.2
            case 3:
            return self.memoryTypes.3
            case 4:
            return self.memoryTypes.4
            case 5:
            return self.memoryTypes.5
            case 6:
            return self.memoryTypes.6
            case 7:
            return self.memoryTypes.0
            case 8:
            return self.memoryTypes.1
            case 9:
            return self.memoryTypes.2
            case 10:
            return self.memoryTypes.3
            case 11:
            return self.memoryTypes.4
            case 12:
            return self.memoryTypes.5
            case 13:
            return self.memoryTypes.6
            case 14:
            return self.memoryTypes.0
            case 15:
            return self.memoryTypes.1
            case 16:
            return self.memoryTypes.2
            case 17:
            return self.memoryTypes.3
            case 18:
            return self.memoryTypes.4
            case 19:
            return self.memoryTypes.5
            case 20:
            return self.memoryTypes.6
            case 21:
            return self.memoryTypes.0
            case 22:
            return self.memoryTypes.1
            case 23:
            return self.memoryTypes.2
            case 24:
            return self.memoryTypes.3
            case 25:
            return self.memoryTypes.4
            case 26:
            return self.memoryTypes.5
            case 27:
            return self.memoryTypes.6
            case 28:
            return self.memoryTypes.0
            case 29:
            return self.memoryTypes.1
            case 30:
            return self.memoryTypes.2
            case 31:
            return self.memoryTypes.3
            default:
            throw MemoryError.noSuitableMemoryType
        }
    }
}