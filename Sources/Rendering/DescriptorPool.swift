import Vulkan 

class DescriptorPool {

    var vkPool: VkDescriptorPool!
    let device: Device

    init(device: Device) {
        self.device = device
        let poolSizes: UnsafeMutablePointer<VkDescriptorPoolSize> = .allocate(capacity: 2)
        poolSizes[0] = VkDescriptorPoolSize(type: VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER, descriptorCount: 10)
        poolSizes[1] = VkDescriptorPoolSize(type: VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC, descriptorCount: 10)

        var info = VkDescriptorPoolCreateInfo(
            sType: VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO, 
            pNext: nil, 
            flags: 0, 
            maxSets: 10, 
            poolSizeCount: 2, 
            pPoolSizes: poolSizes
        )

        vkHandleSafe(vkCreateDescriptorPool(device.device, &info, nil, &vkPool))
        poolSizes.deallocate()
    } 

    func allocate(count: UInt32, target: UnsafeMutablePointer<VkDescriptorSet?>, layout: UnsafeMutablePointer<VkDescriptorSetLayout?>) {

        var info = VkDescriptorSetAllocateInfo(
            sType: VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO, 
            pNext: nil, 
            descriptorPool: vkPool, 
            descriptorSetCount: count, 
            pSetLayouts: layout
        )

        vkHandleSafe(
            vkAllocateDescriptorSets(
                device.device, 
                &info, 
                target
            )
        )
    }
}