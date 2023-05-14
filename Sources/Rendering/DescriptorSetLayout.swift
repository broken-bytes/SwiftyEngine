import Vulkan

protocol DescriptorSetLayout {

    var vkLayout: VkDescriptorSetLayout! { get }
}

class MVPDescriptorSetLayout: DescriptorSetLayout {

    var vkLayout: VkDescriptorSetLayout!

    init(device: Device) {
        // Create barebone descriptors that every shader need
        let projectionBufferBinding = VkDescriptorSetLayoutBinding(
            binding: 0, 
            descriptorType: VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER, 
            descriptorCount: 1, 
            stageFlags: UInt32(VK_SHADER_STAGE_VERTEX_BIT.rawValue), 
            pImmutableSamplers: nil
        )

        let bindingPtr: UnsafeMutablePointer<VkDescriptorSetLayoutBinding> = .allocate(capacity: 1)
        bindingPtr.initialize(to: projectionBufferBinding)

	    var setinfo = VkDescriptorSetLayoutCreateInfo(
            sType: VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO, 
            pNext: nil, 
            flags: 0, 
            bindingCount: 1, 
            pBindings: bindingPtr
        )

	    vkHandleSafe(vkCreateDescriptorSetLayout(device.device, &setinfo, nil, &vkLayout))
        bindingPtr.deallocate()
    }
}