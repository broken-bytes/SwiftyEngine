import Vulkan

class StagingBuffer {

    var vkBuffer: VkBuffer!
    private var memory: VkDeviceMemory!
    private let device: Device

    init(device: Device, sizeInBytes: UInt64) {
        self.device = device
        var bufferInfo = VkBufferCreateInfo()
	    bufferInfo.sType = VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO
	    bufferInfo.pNext = nil
	    bufferInfo.size = sizeInBytes
	    bufferInfo.usage = UInt32(VK_BUFFER_USAGE_TRANSFER_SRC_BIT.rawValue)

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
}