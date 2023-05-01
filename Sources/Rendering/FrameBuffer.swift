import Vulkan

class FrameBuffer {

    var vkFrameBuffer: UnsafeMutablePointer<VkFramebuffer?>

    init(
        device: Device,
        width: UInt32,
        height: UInt32,
        renderPass: RenderPass,
        imageView: VkImageView?
    ) {
        print("FRAMEBUFFER - BEFORE")
        var info = VkFramebufferCreateInfo()
	    info.sType = VK_STRUCTURE_TYPE_FRAMEBUFFER_CREATE_INFO
	    info.pNext = nil
	    info.renderPass = renderPass.vkRenderPass.pointee
	    info.attachmentCount = 1
	    info.width = width
	    info.height = height
	    info.layers = 1
        withUnsafePointer(to: imageView) {
            info.pAttachments = $0
        }

        vkFrameBuffer = .allocate(capacity: 1)

        print("FRAMEBUFFER - Pass: \(renderPass.vkRenderPass.pointee)")
        print("FRAMEBUFFER - Device: \(device.device.pointee)")
        vkHandleSafe(vkCreateFramebuffer(device.device.pointee, &info, nil, vkFrameBuffer))
        print("FRAMEBUFFER - AFTER")
    }

    deinit {
        vkFrameBuffer.deallocate()
    }
}