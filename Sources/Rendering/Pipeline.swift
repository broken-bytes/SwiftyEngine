import Core
import Models
import Vulkan

class Pipeline: Identifiable {
    typealias ID = UInt32

    private static var pipelineIds: [ID] = []

    let id: ID
    var vkPipeline: VkPipeline?
    var device: Device
    var vertexShader: Shader
    var pixelShader: Shader

    init(device: Device, vertexShader: Shader, pixelShader: Shader, renderPass: RenderPass, layouts: [DescriptorSetLayout]) {
        self.id = Pipeline.pipelineIds.nextFreeValue
        Pipeline.pipelineIds.append(id)
        self.device = device
        self.vertexShader = vertexShader
        self.pixelShader = pixelShader

        let stage = PipelineStage(vertexShader: vertexShader, pixelShader: pixelShader)
        let layout = PipelineLayout(device: device, layouts: layouts)

        let dynamics = [
            VK_DYNAMIC_STATE_VIEWPORT,
            VK_DYNAMIC_STATE_SCISSOR
        ]

        let dynamicsPtr: UnsafeMutablePointer<VkDynamicState> = .allocate(capacity: 2)
        dynamicsPtr[0] =  dynamics[0]
        dynamicsPtr[1] =  dynamics[1]

        var dynamicState = VkPipelineDynamicStateCreateInfo(
            sType: VK_STRUCTURE_TYPE_PIPELINE_DYNAMIC_STATE_CREATE_INFO, 
            pNext: nil, 
            flags: 0, 
            dynamicStateCount: UInt32(dynamics.count), 
            pDynamicStates: dynamicsPtr
        )

        var inputAssembly = VkPipelineInputAssemblyStateCreateInfo(
            sType: VK_STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO, 
            pNext: nil, 
            flags: 0, 
            topology: VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST, 
            primitiveRestartEnable: VK_FALSE
        )

        var viewportState = VkPipelineViewportStateCreateInfo(
            sType: VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_STATE_CREATE_INFO, 
            pNext: nil, 
            flags: 0, 
            viewportCount: 1, 
            pViewports: nil, 
            scissorCount: 1, 
            pScissors: nil
        )

        var rasterizer = VkPipelineRasterizationStateCreateInfo(
            sType: VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_CREATE_INFO, 
            pNext: nil, 
            flags: 0, 
            depthClampEnable: VK_FALSE, 
            rasterizerDiscardEnable: VK_FALSE, 
            polygonMode: VK_POLYGON_MODE_FILL, 
            cullMode: UInt32(VK_CULL_MODE_BACK_BIT.rawValue), 
            frontFace: VK_FRONT_FACE_CLOCKWISE, 
            depthBiasEnable: VK_FALSE, 
            depthBiasConstantFactor: 0, 
            depthBiasClamp: 0, 
            depthBiasSlopeFactor: 0, 
            lineWidth: 1
        )  

        var multisampling = VkPipelineMultisampleStateCreateInfo(
            sType: VK_STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO, 
            pNext: nil, 
            flags: 0, 
            rasterizationSamples: VK_SAMPLE_COUNT_1_BIT, 
            sampleShadingEnable: VK_FALSE, 
            minSampleShading: 1, 
            pSampleMask: nil, 
            alphaToCoverageEnable: VK_FALSE, 
            alphaToOneEnable: VK_FALSE
        )

        var colorBlendAttachment = VkPipelineColorBlendAttachmentState(
            blendEnable: VK_FALSE, 
            srcColorBlendFactor: VK_BLEND_FACTOR_ONE, 
            dstColorBlendFactor: VK_BLEND_FACTOR_ZERO, 
            colorBlendOp: VK_BLEND_OP_ADD, 
            srcAlphaBlendFactor: VK_BLEND_FACTOR_ONE, 
            dstAlphaBlendFactor: VK_BLEND_FACTOR_ZERO, 
            alphaBlendOp: VK_BLEND_OP_ADD, 
            colorWriteMask: UInt32(VK_COLOR_COMPONENT_R_BIT.rawValue | VK_COLOR_COMPONENT_G_BIT.rawValue | VK_COLOR_COMPONENT_B_BIT.rawValue | VK_COLOR_COMPONENT_A_BIT.rawValue)
        )

        let colAttPtr: UnsafeMutablePointer<VkPipelineColorBlendAttachmentState> = .allocate(capacity: 1)
        colAttPtr.initialize(to: colorBlendAttachment)

        var colorBlending = VkPipelineColorBlendStateCreateInfo(
            sType: VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO, 
            pNext: nil, 
            flags: 0, 
            logicOpEnable: VK_FALSE, 
            logicOp: VK_LOGIC_OP_COPY, 
            attachmentCount: 1, 
            pAttachments: colAttPtr, 
            blendConstants: (0, 0, 0, 0)
        )

        let stagesPtr = UnsafeMutablePointer<VkPipelineShaderStageCreateInfo>.allocate(capacity: 2)

        stagesPtr[0] = stage.stages[0]
        stagesPtr[1] = stage.stages[1]

        let inpPtr = UnsafeMutablePointer<VkPipelineInputAssemblyStateCreateInfo>.allocate(capacity: 1)
        inpPtr.initialize(to: inputAssembly)

        let viewPtr = UnsafeMutablePointer<VkPipelineViewportStateCreateInfo>.allocate(capacity: 1)
        viewPtr.initialize(to: viewportState)

        let rastPtr = UnsafeMutablePointer<VkPipelineRasterizationStateCreateInfo>.allocate(capacity: 1)
        rastPtr.initialize(to: rasterizer)

        let multPtr = UnsafeMutablePointer<VkPipelineMultisampleStateCreateInfo>.allocate(capacity: 1)
        multPtr.initialize(to: multisampling)

        let colPtr = UnsafeMutablePointer<VkPipelineColorBlendStateCreateInfo>.allocate(capacity: 1)
        colPtr.initialize(to: colorBlending)

        let dynPtr = UnsafeMutablePointer<VkPipelineDynamicStateCreateInfo>.allocate(capacity: 1)
        dynPtr.initialize(to: dynamicState)    
    
        // TODO: BINDINGS MEAN DIFFERENT BUFFERS
        let bindingDescriptions = [
            VkVertexInputBindingDescription(
                binding: 0, 
                stride: UInt32(MemoryLayout<Vertex>.size), 
                inputRate: VK_VERTEX_INPUT_RATE_VERTEX
            ),      
        ]

        let attributes: [VkVertexInputAttributeDescription] = [
            VkVertexInputAttributeDescription(
                location: 0, 
                binding: bindingDescriptions[0].binding, 
                format: VK_FORMAT_R32G32B32_SFLOAT, 
                offset: 0
            ),
            VkVertexInputAttributeDescription(
                location: 1, 
                binding: bindingDescriptions[0].binding, 
                format: VK_FORMAT_R32G32_SFLOAT, 
                offset: 12
            ),
            VkVertexInputAttributeDescription(
                location: 2, 
                binding: bindingDescriptions[0].binding, 
                format: VK_FORMAT_R32G32B32A32_SFLOAT, 
                offset: 20
            ),
        ]

        let bindings = UnsafeMutablePointer<VkVertexInputBindingDescription>.allocate(capacity: 3)
        bindings[0] = bindingDescriptions[0]

        let attrPtr = UnsafeMutablePointer<VkVertexInputAttributeDescription>.allocate(capacity: 3)
        attrPtr[0] = attributes[0]
        attrPtr[1] = attributes[1]
        attrPtr[2] = attributes[2]

        let vertexInputStateInfo = VkPipelineVertexInputStateCreateInfo(
            sType: VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO, 
            pNext: nil,
            flags: 0, 
            vertexBindingDescriptionCount: UInt32(bindingDescriptions.count),
            pVertexBindingDescriptions: bindings,
            vertexAttributeDescriptionCount: UInt32(attributes.count), 
            pVertexAttributeDescriptions: attrPtr
        )

        let vertStatePtr = UnsafeMutablePointer<VkPipelineVertexInputStateCreateInfo>.allocate(capacity: 1)
        vertStatePtr.initialize(to: vertexInputStateInfo)

        var pipelineInfo = VkGraphicsPipelineCreateInfo(
            sType: VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO, 
            pNext: nil, 
            flags: 0, 
            stageCount: UInt32(stage.stages.count), 
            pStages: stagesPtr, 
            pVertexInputState: vertStatePtr, 
            pInputAssemblyState: inpPtr, 
            pTessellationState: nil, 
            pViewportState: viewPtr, 
            pRasterizationState: rastPtr, 
            pMultisampleState: multPtr, 
            pDepthStencilState: nil, 
            pColorBlendState: colPtr, 
            pDynamicState: dynPtr, 
            layout: layout.vkPipelineLayout, 
            renderPass: renderPass.vkRenderPass, 
            subpass: 0, 
            basePipelineHandle: nil, 
            basePipelineIndex: -1
        )
        vkHandleSafe(vkCreateGraphicsPipelines(device.device, nil, 1, &pipelineInfo, nil, &vkPipeline))
    }

    deinit {
        vkDestroyPipeline(device.device, vkPipeline, nil)
    }
}