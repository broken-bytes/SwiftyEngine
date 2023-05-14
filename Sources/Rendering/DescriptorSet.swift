import Vulkan 

class DescriptorSet {

    var vkDescriptorSet: VkDescriptorSet!
    private let device: Device

    init(device: Device, info: inout VkDescriptorSetAllocateInfo) {
        self.device = device
        vkHandleSafe(
            vkAllocateDescriptorSets(
                device.device, 
                &info, 
                &vkDescriptorSet
            )
        )
    }

    func update(buffer: UniformBuffer, offset: UInt64, bytes: UInt64) {
        var bufferInfo = VkDescriptorBufferInfo(
            buffer: buffer.vkBuffer, 
            offset: offset, 
            range: bytes
        )

        var bufferInfoPtr: UnsafeMutablePointer<VkDescriptorBufferInfo> = .allocate(capacity: 1)
        bufferInfoPtr.initialize(to: bufferInfo)

        var writeInfo = VkWriteDescriptorSet(
            sType: VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET, 
            pNext: nil, 
            dstSet: self.vkDescriptorSet, 
            dstBinding: 0, 
            dstArrayElement: 0, 
            descriptorCount: 1, 
            descriptorType: VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC, 
            pImageInfo: nil, 
            pBufferInfo: bufferInfoPtr, 
            pTexelBufferView: nil
        )

        vkUpdateDescriptorSets(device.device, 1, &writeInfo, 0, nil)
    }
}