import Core
import Vulkan

class Image {

    private static var imageIds: [UInt32] = []
    var id: UInt32
    var vkImage: VkImage!
    private var memory: VkDeviceMemory!

    init(device: Device, width: UInt32, height: UInt32, tiling: VkImageTiling, usage: VkImageUsageFlags, properties: VkMemoryPropertyFlags) {
        self.id = Image.imageIds.nextFreeValue
        Image.imageIds.append(self.id)
        var imageExtent = VkExtent3D(width: width, height: height, depth: 1)

	    var info = VkImageCreateInfo(
            sType: VK_STRUCTURE_TYPE_IMAGE_CREATE_INFO, 
            pNext: nil, 
            flags: 0, 
            imageType: VK_IMAGE_TYPE_2D, 
            format: VK_FORMAT_R8G8B8A8_SRGB, 
            extent: imageExtent, 
            mipLevels: 1, 
            arrayLayers: 1, 
            samples: VK_SAMPLE_COUNT_1_BIT, 
            tiling: tiling, 
            usage: UInt32(VK_IMAGE_USAGE_TRANSFER_DST_BIT.rawValue | VK_IMAGE_USAGE_SAMPLED_BIT.rawValue), 
            sharingMode: VK_SHARING_MODE_EXCLUSIVE, 
            queueFamilyIndexCount: 0, 
            pQueueFamilyIndices: nil, 
            initialLayout: VK_IMAGE_LAYOUT_UNDEFINED
        )

        vkHandleSafe(vkCreateImage(device.device, &info, nil, &vkImage))

        var memRequirements: UnsafeMutablePointer<VkMemoryRequirements> = .allocate(capacity: 1)
        vkGetImageMemoryRequirements(device.device, vkImage, memRequirements)

        var allocInfo = VkMemoryAllocateInfo(
            sType: VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO, 
            pNext: nil, 
            allocationSize: memRequirements.pointee.size, 
            memoryTypeIndex: try! MemoryHelpers.findMemoryType(device: device, for: memRequirements.pointee.memoryTypeBits, and: properties)
        )

        vkHandleSafe(vkAllocateMemory(device.device, &allocInfo, nil, &memory))
        vkHandleSafe(vkBindImageMemory(device.device, vkImage, memory, 0))

        memRequirements.deallocate()
    }
}