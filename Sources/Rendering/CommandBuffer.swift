import Vulkan

class CommandBuffer {

    var device: Device
    var vkCommandBuffer: VkCommandBuffer?
    var clearColor: VkClearValue

    init(device: Device, commandPool: CommandPool) {

        var info = VkCommandBufferAllocateInfo()
	    info.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO
	    info.pNext = nil
	    info.commandPool = commandPool.vkCommandPool.pointee
	    info.commandBufferCount = 1
	    info.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY
	    vkHandleSafe(vkAllocateCommandBuffers(device.device.pointee, &info, &vkCommandBuffer))

        clearColor = VkClearValue()
        clearColor.color = VkClearColorValue()
        clearColor.color.float32 = (1, 1, 1, 1)
        clearColor.depthStencil = VkClearDepthStencilValue()
        clearColor.depthStencil.depth = (1)
        self.device = device
    }
    
    func execute(
        framebuffer: FrameBuffer, 
        renderPass: RenderPass,
        extent: VkExtent2D,
        _ block: @escaping () -> Void
    ) {
        var info = VkCommandBufferBeginInfo()
        info.pNext = nil
        info.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO
        info.pInheritanceInfo = nil
        info.flags = UInt32(VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT.rawValue)
        vkHandleSafe(vkBeginCommandBuffer(vkCommandBuffer, &info))
        
        var renderPassInfo = VkRenderPassBeginInfo()
	    renderPassInfo.sType = VK_STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO
	    renderPassInfo.pNext = nil

	    renderPassInfo.renderPass = renderPass.vkRenderPass.pointee
	    renderPassInfo.renderArea.offset.x = 0
	    renderPassInfo.renderArea.offset.y = 0
	    renderPassInfo.renderArea.extent = extent
	    renderPassInfo.framebuffer = framebuffer.vkFrameBuffer.pointee
	    renderPassInfo.clearValueCount = 1
        withUnsafePointer(to: &clearColor) {
            renderPassInfo.pClearValues = $0
        }

	    vkCmdBeginRenderPass(vkCommandBuffer, &renderPassInfo, VK_SUBPASS_CONTENTS_INLINE)
        block()

        vkCmdEndRenderPass(vkCommandBuffer)
        vkHandleSafe(vkEndCommandBuffer(vkCommandBuffer))
    }

    func reset() {
        vkHandleSafe(vkResetCommandBuffer(vkCommandBuffer, 0));
    }

    func setClearColor(color: VkClearValue) {
        self.clearColor = color
    }
}