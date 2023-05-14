import Vulkan

class Queue {

    var vkQueue: VkQueue?

    init(device: Device, familyIndex: UInt32) {
        vkGetDeviceQueue(device.device, familyIndex, 0, &vkQueue)
    }

    func submit(
        renderSemaphore: inout Semaphore, 
        presentSemaphore: inout Semaphore,
        commandBuffers: [CommandBuffer],
        fence: Fence
    ) { 
        var submit = VkSubmitInfo()
	    submit.sType = VK_STRUCTURE_TYPE_SUBMIT_INFO
	    submit.pNext = nil

	    var waitStage: VkPipelineStageFlags = UInt32(VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT.rawValue)

        withUnsafePointer(to: &waitStage) {
	        submit.pWaitDstStageMask = $0
        }

	    submit.waitSemaphoreCount = 1

        withUnsafePointer(to: &presentSemaphore.vkSemaphore) {
	        submit.pWaitSemaphores = $0
        }

	    submit.signalSemaphoreCount = 1
	    withUnsafePointer(to: &renderSemaphore.vkSemaphore) {
	        submit.pSignalSemaphores = $0
        }

	    submit.commandBufferCount = UInt32(commandBuffers.count)
        commandBuffers
            .map { $0.vkCommandBuffer}
            .withUnsafeBufferPointer { submit.pCommandBuffers = $0.baseAddress }

        vkHandleSafe(vkQueueSubmit(vkQueue, 1, &submit, fence.vkFence))
    }

    func submit(commandBuffers: [CommandBuffer], fence: Fence) {
        var submit = VkSubmitInfo()
	    submit.sType = VK_STRUCTURE_TYPE_SUBMIT_INFO
	    submit.pNext = nil
        submit.pWaitDstStageMask = nil
	    submit.waitSemaphoreCount = 0
	    submit.pWaitSemaphores = nil
	    submit.signalSemaphoreCount = 0
	    submit.pSignalSemaphores = nil
	    submit.commandBufferCount = UInt32(commandBuffers.count)
        commandBuffers
            .map { $0.vkCommandBuffer}
            .withUnsafeBufferPointer { submit.pCommandBuffers = $0.baseAddress }

        vkHandleSafe(vkQueueSubmit(vkQueue, 1, &submit, fence.vkFence))
    }

    func present(
        swapchain: Swapchain, 
        renderSemaphore: inout Semaphore, 
        swapchainImageIndex: inout UInt32
    ) {
        var presentInfo = VkPresentInfoKHR()
	    presentInfo.sType = VK_STRUCTURE_TYPE_PRESENT_INFO_KHR
	    presentInfo.pNext = nil

        withUnsafePointer(to: &swapchain.vkSwapchain) {
            presentInfo.pSwapchains = $0
        }

	    presentInfo.swapchainCount = 1

        withUnsafePointer(to: &renderSemaphore.vkSemaphore) {
	        presentInfo.pWaitSemaphores = $0
        }

	    presentInfo.waitSemaphoreCount = 1

        withUnsafePointer(to: &swapchainImageIndex) {
	        presentInfo.pImageIndices = $0
        }

	    vkHandleSafe(vkQueuePresentKHR(vkQueue, &presentInfo))
    }
}