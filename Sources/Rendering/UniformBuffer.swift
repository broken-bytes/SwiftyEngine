import Foundation
import Vulkan 

class UniformBuffer {

    var vkBuffer: VkBuffer!
    private let device: Device
    private var memory: VkDeviceMemory!

    init(device: Device, sizeInBytes: UInt64, flags: VkBufferUsageFlags) {
        self.device = device
        var bufferInfo = VkBufferCreateInfo()
	    bufferInfo.sType = VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO
	    bufferInfo.pNext = nil
	    bufferInfo.size = sizeInBytes
	    bufferInfo.usage = flags

        vkHandleSafe(vkCreateBuffer(device.device, &bufferInfo, nil, &vkBuffer))
        var memReq: UnsafeMutablePointer<VkMemoryRequirements> = .allocate(capacity: 1)
        vkGetBufferMemoryRequirements(device.device, vkBuffer, memReq)

        do {
            let memIndex = try MemoryHelpers.findMemoryType(
                device: device, 
                for: memReq.pointee.memoryTypeBits, 
                and: VkMemoryPropertyFlags((VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT.rawValue))
            )

            var allocInfo = VkMemoryAllocateInfo(
                sType: VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO, 
                pNext: nil, 
                allocationSize: memReq.pointee.size, 
                memoryTypeIndex: memIndex
            )
            
            vkAllocateMemory(device.device, &allocInfo, nil, &memory)
            vkBindBufferMemory(device.device, vkBuffer, memory, 0)
        } catch {
            fatalError("Failed to get memory type for buffer")
        }
    }

    func writeBytes(numBytes: UInt64, bytes: UnsafeMutableRawPointer, offset: UInt64) {
        var mappedMemory: UnsafeMutableRawPointer? = nil
        vkMapMemory(device.device, memory, offset, numBytes, 0, &mappedMemory)
        memcpy(mappedMemory, bytes, Int(numBytes))
        vkUnmapMemory(device.device, memory)
    }

    deinit {
        vkDestroyBuffer(device.device, vkBuffer, nil)
        vkFreeMemory(device.device, memory, nil)
    }
}