import Foundation
import Models
import Vulkan 

class VertexBuffer {

    var vkBuffer: VkBuffer?
    var memory: VkDeviceMemory?
    let count: UInt32
    let device: Device

    internal init(device: Device, with vertices: [Vertex]) {
        self.device = device
        var bufferInfo = VkBufferCreateInfo()   
        bufferInfo.sType = VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
        bufferInfo.size = UInt64(MemoryLayout<Vertex>.size * vertices.count)
        count = UInt32(vertices.count)
        bufferInfo.usage = UInt32(VK_BUFFER_USAGE_VERTEX_BUFFER_BIT.rawValue)
        bufferInfo.sharingMode = VK_SHARING_MODE_EXCLUSIVE
        vkHandleSafe(vkCreateBuffer(device.device, &bufferInfo, nil, &vkBuffer))
        
        var memRequirements = VkMemoryRequirements()
        vkGetBufferMemoryRequirements(device.device, vkBuffer, &memRequirements)
        var allocInfo = VkMemoryAllocateInfo()
        allocInfo.sType = VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO
        allocInfo.allocationSize = memRequirements.size
        allocInfo.memoryTypeIndex = try! MemoryHelpers.findMemoryType(
            device: device,
            for: memRequirements.memoryTypeBits, 
            and: VkMemoryPropertyFlags(VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT.rawValue | VK_MEMORY_PROPERTY_HOST_COHERENT_BIT.rawValue))

        vkHandleSafe(vkAllocateMemory(device.device, &allocInfo, nil, &memory))
        vkHandleSafe(vkBindBufferMemory(device.device, vkBuffer, memory, 0))

        var rawData: UnsafeMutableRawPointer! = nil
        vkMapMemory(device.device, memory, 0, bufferInfo.size, 0, &rawData)
        memcpy(rawData, vertices, Int(bufferInfo.size))
        vkUnmapMemory(device.device, memory)
    }

    deinit {
        vkDestroyBuffer(device.device, vkBuffer, nil)
        vkFreeMemory(device.device, memory, nil)
    }
}