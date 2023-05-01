import Vulkan

class CommandBuffer {

    var vkCommandBuffer: UnsafeMutablePointer<VkCommandBuffer?>

    init(device: Device, commandPool: CommandPool) {
        vkCommandBuffer = .allocate(capacity: 1)

        var info = VkCommandBufferAllocateInfo()
	    info.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
	    info.pNext = nil;
	    info.commandPool = commandPool.vkCommandPool.pointee;
	    info.commandBufferCount = 1;
	    info.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
	    vkHandleSafe(vkAllocateCommandBuffers(device.device.pointee, &info, vkCommandBuffer));        
    }

    func execute(_ block: @escaping () -> Void) {
        var info = VkCommandBufferBeginInfo()
        info.pNext = nil
        info.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO
        vkHandleSafe(vkBeginCommandBuffer(vkCommandBuffer.pointee, &info))

        block()

        vkEndCommandBuffer(vkCommandBuffer.pointee)
    }

    func renderpass(_ block: @escaping () -> Void) {
        //vkCmdBeginRenderPass(vkCommandBuffer.pointee, pRenderPassBegin: UnsafePointer<VkRenderPassBeginInfo>!, contents: VkSubpassContents)
    }
}