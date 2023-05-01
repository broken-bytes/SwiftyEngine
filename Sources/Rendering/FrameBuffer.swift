import Vulkan

class FrameBuffer {

    var vkFrameBuffer: VkFramebuffer?
    var device: Device

    init(
        device: Device,
        width: UInt32,
        height: UInt32,
        renderPass: RenderPass,
        imageView: VkImageView?
    ) {
        self.device = device

        var info = VkFramebufferCreateInfo()
	    info.sType = VK_STRUCTURE_TYPE_FRAMEBUFFER_CREATE_INFO
	    info.pNext = nil
	    info.renderPass = renderPass.vkRenderPass
	    info.attachmentCount = 1
	    info.width = width
	    info.height = height
	    info.layers = 1
        withUnsafePointer(to: imageView) {
            info.pAttachments = $0
        }

        vkHandleSafe(vkCreateFramebuffer(device.device, &info, nil, &vkFrameBuffer))
    }

    deinit {
        vkDestroyFramebuffer(device.device, vkFrameBuffer, nil)
    }
}