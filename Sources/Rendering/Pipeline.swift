import Vulkan

class Pipeline {

    var vkPipeline: VkPipeline?
    var device: Device

    init(device: Device, vertexShader: Shader, pixelShader: Shader, renderPass: RenderPass) {
        self.device = device

        let stage = PipelineStage(vertexShader: vertexShader, pixelShader: pixelShader)
        let layout = PipelineLayout(device: device)

        var dynamics = [
            VK_DYNAMIC_STATE_VIEWPORT,
            VK_DYNAMIC_STATE_SCISSOR
        ]

        var dynamicState = VkPipelineDynamicStateCreateInfo()
        dynamicState.sType = VK_STRUCTURE_TYPE_PIPELINE_DYNAMIC_STATE_CREATE_INFO;
        dynamicState.dynamicStateCount = UInt32(dynamics.count)

        dynamics.withUnsafeBufferPointer {
            dynamicState.pDynamicStates = $0.baseAddress
        }

        var vertexInputInfo = VkPipelineVertexInputStateCreateInfo()
        vertexInputInfo.sType = VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO
        vertexInputInfo.vertexBindingDescriptionCount = 0
        vertexInputInfo.pVertexBindingDescriptions = nil // Optional
        vertexInputInfo.vertexAttributeDescriptionCount = 0
        vertexInputInfo.pVertexAttributeDescriptions = nil // Optional

        var inputAssembly = VkPipelineInputAssemblyStateCreateInfo()
        inputAssembly.sType = VK_STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO
        inputAssembly.topology = VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST
        inputAssembly.primitiveRestartEnable = VK_FALSE

        var viewportState = VkPipelineViewportStateCreateInfo()
        viewportState.sType = VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_STATE_CREATE_INFO
        viewportState.viewportCount = 1
        viewportState.scissorCount = 1

        var rasterizer = VkPipelineRasterizationStateCreateInfo()
        rasterizer.sType = VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_CREATE_INFO
        rasterizer.depthClampEnable = VK_FALSE
        rasterizer.rasterizerDiscardEnable = VK_FALSE
        rasterizer.polygonMode = VK_POLYGON_MODE_FILL
        rasterizer.lineWidth = 1.0
        rasterizer.cullMode = UInt32(VK_CULL_MODE_BACK_BIT.rawValue)
        rasterizer.frontFace = VK_FRONT_FACE_CLOCKWISE
        rasterizer.depthBiasEnable = VK_FALSE;
        rasterizer.depthBiasConstantFactor = 0.0 // Optional
        rasterizer.depthBiasClamp = 0.0 // Optional
        rasterizer.depthBiasSlopeFactor = 0.0 // Optional     

        var multisampling = VkPipelineMultisampleStateCreateInfo()
        multisampling.sType = VK_STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO
        multisampling.sampleShadingEnable = VK_FALSE
        multisampling.rasterizationSamples = VK_SAMPLE_COUNT_1_BIT
        multisampling.minSampleShading = 1.0 // Optional
        multisampling.pSampleMask = nil // Optional
        multisampling.alphaToCoverageEnable = VK_FALSE // Optional
        multisampling.alphaToOneEnable = VK_FALSE // Optional

        var colorBlendAttachment = VkPipelineColorBlendAttachmentState()
        colorBlendAttachment.colorWriteMask = UInt32(VK_COLOR_COMPONENT_R_BIT.rawValue | VK_COLOR_COMPONENT_G_BIT.rawValue | VK_COLOR_COMPONENT_B_BIT.rawValue | VK_COLOR_COMPONENT_A_BIT.rawValue)
        colorBlendAttachment.blendEnable = VK_FALSE
        colorBlendAttachment.srcColorBlendFactor = VK_BLEND_FACTOR_ONE // Optional
        colorBlendAttachment.dstColorBlendFactor = VK_BLEND_FACTOR_ZERO // Optional
        colorBlendAttachment.colorBlendOp = VK_BLEND_OP_ADD // Optional
        colorBlendAttachment.srcAlphaBlendFactor = VK_BLEND_FACTOR_ONE // Optional
        colorBlendAttachment.dstAlphaBlendFactor = VK_BLEND_FACTOR_ZERO // Optional
        colorBlendAttachment.alphaBlendOp = VK_BLEND_OP_ADD // Optional

        var colorBlending = VkPipelineColorBlendStateCreateInfo()
        colorBlending.sType = VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO
        colorBlending.logicOpEnable = VK_FALSE
        colorBlending.logicOp = VK_LOGIC_OP_COPY // Optional
        colorBlending.attachmentCount = 1
        withUnsafePointer(to: &colorBlendAttachment) {
            colorBlending.pAttachments = $0
        }
        colorBlending.blendConstants.0 = 0.0 // Optional
        colorBlending.blendConstants.1 = 0.0 // Optional
        colorBlending.blendConstants.2 = 0.0 // Optional
        colorBlending.blendConstants.3 = 0.0 // Optional

        var pipelineInfo = VkGraphicsPipelineCreateInfo()
        pipelineInfo.sType = VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO
        pipelineInfo.stageCount = UInt32(stage.stages.count)
        stage.stages.withUnsafeBufferPointer {
            pipelineInfo.pStages = $0.baseAddress
        }

        withUnsafePointer(to: &vertexInputInfo) {
            pipelineInfo.pVertexInputState = $0
        }

        withUnsafePointer(to: &inputAssembly) {
            pipelineInfo.pInputAssemblyState = $0
        }

        withUnsafePointer(to: &viewportState) {
            pipelineInfo.pViewportState = $0
        }

        withUnsafePointer(to: &rasterizer) {
            pipelineInfo.pRasterizationState = $0
        }

        withUnsafePointer(to: &multisampling) {
            pipelineInfo.pMultisampleState = $0
        }

        pipelineInfo.pDepthStencilState = nil

        withUnsafePointer(to: &colorBlending) {
            pipelineInfo.pColorBlendState = $0
        }

        withUnsafePointer(to: &dynamicState) {
            pipelineInfo.pDynamicState = $0
        }

        pipelineInfo.layout = layout.vkPipelineLayout
        pipelineInfo.renderPass = renderPass.vkRenderPass
        pipelineInfo.subpass = 0
        pipelineInfo.basePipelineHandle = nil // Optional
        pipelineInfo.basePipelineIndex = -1 // Optional

        vkHandleSafe(vkCreateGraphicsPipelines(device.device, nil, 1, &pipelineInfo, nil, &vkPipeline))
    }

    deinit {
        vkDestroyPipeline(device.device, vkPipeline, nil)
    }
}