import Models
import Vulkan

class CommandBuffer {

    var vkCommandBuffer: VkCommandBuffer?
    var device: Device
    var clearColor: VkClearValue

    init(device: Device, commandPool: CommandPool) {

        var info = VkCommandBufferAllocateInfo()
	    info.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO
	    info.pNext = nil
	    info.commandPool = commandPool.vkCommandPool
	    info.commandBufferCount = 1
	    info.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY
	    vkHandleSafe(vkAllocateCommandBuffers(device.device, &info, &vkCommandBuffer))

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
        _ block: @escaping (CommandBuffer) -> Void
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

	    renderPassInfo.renderPass = renderPass.vkRenderPass
	    renderPassInfo.renderArea.offset.x = 0
	    renderPassInfo.renderArea.offset.y = 0
	    renderPassInfo.renderArea.extent = extent
	    renderPassInfo.framebuffer = framebuffer.vkFrameBuffer
	    renderPassInfo.clearValueCount = 1
        withUnsafePointer(to: &clearColor) {
            renderPassInfo.pClearValues = $0
        }

	    vkCmdBeginRenderPass(vkCommandBuffer, &renderPassInfo, VK_SUBPASS_CONTENTS_INLINE)
        block(self)

        vkCmdEndRenderPass(vkCommandBuffer)
        vkHandleSafe(vkEndCommandBuffer(vkCommandBuffer))
    }

    func execute(_ block: @escaping (CommandBuffer) -> Void) {
        var info = VkCommandBufferBeginInfo()
        info.pNext = nil
        info.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO
        info.pInheritanceInfo = nil
        info.flags = UInt32(VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT.rawValue)
        vkHandleSafe(vkBeginCommandBuffer(vkCommandBuffer, &info))

        block(self)

        vkEndCommandBuffer(vkCommandBuffer)
    }

    func reset() {
        vkHandleSafe(vkResetCommandBuffer(vkCommandBuffer, 0));
    }

    func bind(to pipeline: Pipeline) {
        vkCmdBindPipeline(vkCommandBuffer, VK_PIPELINE_BIND_POINT_GRAPHICS, pipeline.vkPipeline)
    }

    func bind(to buffer: VertexBuffer) {
        var offsets: [UInt64] = [0]
        vkCmdBindVertexBuffers(vkCommandBuffer, 0, 1, &buffer.vkBuffer, &offsets)
    }
    
    func bind(to buffer: IndexBuffer) {
        var offset: UInt64 = 0
        vkCmdBindIndexBuffer(vkCommandBuffer, buffer.vkBuffer, offset, VK_INDEX_TYPE_UINT16)
    }

    func bind(descriptor: DescriptorSet, at slot: UInt32, layout: VkPipelineLayout, offset: UInt32) {
        var offsets: UInt32 = offset
        vkCmdBindDescriptorSets(vkCommandBuffer, VK_PIPELINE_BIND_POINT_GRAPHICS, layout, slot, 1, &descriptor.vkDescriptorSet, 1, &offsets)
    }

    func draw(numVertices: UInt32, numInstaces: UInt32, offset: UInt32, firstInstance: UInt32) {
        vkCmdDraw(vkCommandBuffer, numVertices, numInstaces, offset, firstInstance)
    }

    func drawIndexed(numIndices: UInt32, numInstances: UInt32, offset: Int32, firstIndex: UInt32, firstInstance: UInt32) {
        vkCmdDrawIndexed(vkCommandBuffer, numIndices, numInstances, firstIndex, offset, firstInstance)
    }

    func set(clearColor color: VkClearValue) {
        self.clearColor = color
    }

    func set(viewport: Viewport) {
        var vkViewport: VkViewport = .init(x: Float(viewport.x), y: Float(viewport.y), width: Float(viewport.width), height: Float(viewport.height), minDepth: 0, maxDepth: 1)
        vkCmdSetViewport(vkCommandBuffer, 0, 1, &vkViewport)
    }

    func set(scissor: Rect) {
        var vkRect = VkRect2D(offset: .init(x: scissor.x, y: scissor.y), extent: .init(width: scissor.width, height: scissor.height))
        vkCmdSetScissor(vkCommandBuffer, 0, 1, &vkRect)
    }

    func transition(image: Image, format: VkFormat, from: VkImageLayout, to: VkImageLayout) {
        var barrier = VkImageMemoryBarrier(
            sType: VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER, 
            pNext: nil, 
            srcAccessMask: 0, 
            dstAccessMask: 0, 
            oldLayout: from, 
            newLayout: to, 
            srcQueueFamilyIndex: VK_QUEUE_FAMILY_IGNORED, 
            dstQueueFamilyIndex: VK_QUEUE_FAMILY_IGNORED, 
            image: image.vkImage, 
            subresourceRange: VkImageSubresourceRange()
        )
        barrier.subresourceRange.aspectMask = UInt32(VK_IMAGE_ASPECT_COLOR_BIT.rawValue)
        barrier.subresourceRange.baseMipLevel = 0
        barrier.subresourceRange.levelCount = 1
        barrier.subresourceRange.baseArrayLayer = 0
        barrier.subresourceRange.layerCount = 1

        var sourceStage = VkPipelineStageFlags()
        var destinationStage = VkPipelineStageFlags()

        if from == VK_IMAGE_LAYOUT_UNDEFINED && to == VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL {
            barrier.srcAccessMask = 0
            barrier.dstAccessMask = UInt32(VK_ACCESS_TRANSFER_WRITE_BIT.rawValue)
            sourceStage = UInt32(VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT.rawValue)
            destinationStage = UInt32(VK_PIPELINE_STAGE_TRANSFER_BIT.rawValue)
        } else if from == VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL && to == VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL {
            barrier.srcAccessMask = UInt32(VK_ACCESS_TRANSFER_WRITE_BIT.rawValue)
            barrier.dstAccessMask = UInt32(VK_ACCESS_SHADER_READ_BIT.rawValue)
            sourceStage = UInt32(VK_PIPELINE_STAGE_TRANSFER_BIT.rawValue)
            destinationStage = UInt32(VK_PIPELINE_STAGE_FRAGMENT_SHADER_BIT.rawValue)
        } 

        vkCmdPipelineBarrier(vkCommandBuffer, sourceStage, destinationStage, 0, 0, nil, 0, nil, 1, &barrier)
    }

    func copyBufferToImage(buffer: StagingBuffer, image: Image, width: UInt32, height: UInt32) {
        var region = VkBufferImageCopy(
            bufferOffset: 0, 
            bufferRowLength: 0, 
            bufferImageHeight: 0, 
            imageSubresource: VkImageSubresourceLayers(), 
            imageOffset: VkOffset3D(x: 0, y: 0, z: 0), 
            imageExtent: VkExtent3D(width: width, height: height, depth: 1)
        )

        region.imageSubresource.aspectMask = UInt32(VK_IMAGE_ASPECT_COLOR_BIT.rawValue)
        region.imageSubresource.mipLevel  = 0
        region.imageSubresource.baseArrayLayer = 0
        region.imageSubresource.layerCount = 1

        vkCmdCopyBufferToImage(
            vkCommandBuffer, 
            buffer.vkBuffer, 
            image.vkImage, 
            VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL, 
            1, 
            &region
        )
    }
}