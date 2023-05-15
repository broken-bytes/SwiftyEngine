import Vulkan 

class PipelineLayout {

    var vkPipelineLayout: VkPipelineLayout!
    var device: Device

    init(device: Device, layouts: [DescriptorSetLayout]) {
        self.device = device

        layouts.map { $0.vkLayout }.withUnsafeBufferPointer {
            var pipelineLayoutInfo = VkPipelineLayoutCreateInfo(
                sType: VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO, 
                pNext: nil, 
                flags: 0, 
                setLayoutCount: UInt32(layouts.count), 
                pSetLayouts: $0.baseAddress, 
                pushConstantRangeCount: 0, 
                pPushConstantRanges: nil
            )

            vkHandleSafe(vkCreatePipelineLayout(device.device, &pipelineLayoutInfo, nil, &vkPipelineLayout))
        }
    }

    deinit {
        vkDestroyPipelineLayout(device.device, vkPipelineLayout, nil)
    }
}