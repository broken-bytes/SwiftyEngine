import Vulkan 

class PipelineLayout {

    var vkPipelineLayout: VkPipelineLayout?
    var device: Device

    init(device: Device) {
        self.device = device

        var pipelineLayoutInfo = VkPipelineLayoutCreateInfo()
        pipelineLayoutInfo.sType = VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO
        pipelineLayoutInfo.setLayoutCount = 0 // Optional
        pipelineLayoutInfo.pSetLayouts = nil // Optional
        pipelineLayoutInfo.pushConstantRangeCount = 0 // Optional
        pipelineLayoutInfo.pPushConstantRanges = nil; // Optional

        vkHandleSafe(vkCreatePipelineLayout(device.device, &pipelineLayoutInfo, nil, &vkPipelineLayout))
    }

    deinit {
        vkDestroyPipelineLayout(device.device, vkPipelineLayout, nil)
    }
}