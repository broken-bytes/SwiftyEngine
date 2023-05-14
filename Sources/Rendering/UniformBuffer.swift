import Vulkan 

class UniformBuffer {

    private var vkBuffer: VkBuffer!

    init(device: Device, sizeInBytes: UInt64, flags: VkBufferUsageFlags) {
        var bufferInfo = VkBufferCreateInfo()
	    bufferInfo.sType = VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO
	    bufferInfo.pNext = nil
	    bufferInfo.size = sizeInBytes
	    bufferInfo.usage = flags

        vkHandleSafe(vkCreateBuffer(device.device, &bufferInfo, nil, &vkBuffer))
    }
}