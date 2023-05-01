import Vulkan

class RenderPass {

    var vkRenderPass: UnsafeMutablePointer<VkRenderPass?>

    init(
        device: Device,
        format: VkFormat,
        samples: UInt8,
        useStencil: Bool,
        usedForPresenting: Bool
    ) {
        var colorAttachment = VkAttachmentDescription()
	    colorAttachment.format = format
	    colorAttachment.samples = VK_SAMPLE_COUNT_1_BIT
	    colorAttachment.loadOp = VK_ATTACHMENT_LOAD_OP_CLEAR
	    colorAttachment.storeOp = VK_ATTACHMENT_STORE_OP_STORE
	    colorAttachment.stencilLoadOp = VK_ATTACHMENT_LOAD_OP_DONT_CARE
	    colorAttachment.stencilStoreOp = VK_ATTACHMENT_STORE_OP_DONT_CARE
	    colorAttachment.initialLayout = VK_IMAGE_LAYOUT_UNDEFINED
	    colorAttachment.finalLayout = VK_IMAGE_LAYOUT_PRESENT_SRC_KHR

        
        var colorAttachmentRef = VkAttachmentReference()
	    colorAttachmentRef.attachment = 0
	    colorAttachmentRef.layout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL
	    var subPassDesc = VkSubpassDescription()
	    subPassDesc.pipelineBindPoint = VK_PIPELINE_BIND_POINT_GRAPHICS
	    subPassDesc.colorAttachmentCount = 1

        withUnsafePointer(to: &colorAttachmentRef) {
	        subPassDesc.pColorAttachments = $0
        }

        var renderPassInfo = VkRenderPassCreateInfo()
	    renderPassInfo.sType = VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO
	    renderPassInfo.attachmentCount = 1

        withUnsafePointer(to: &colorAttachment) {
	        renderPassInfo.pAttachments = $0
        }

        renderPassInfo.subpassCount = 1
        withUnsafePointer(to: &subPassDesc) {
	        renderPassInfo.pSubpasses = $0
        }

        vkRenderPass = .allocate(capacity: 1)

	    vkHandleSafe(vkCreateRenderPass(device.device.pointee, &renderPassInfo, nil, vkRenderPass))
    }

    deinit {
        vkRenderPass.deallocate()
    }
}