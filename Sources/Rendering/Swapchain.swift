import Vulkan

class Swapchain {

    var vkSwapchain: UnsafeMutablePointer<VkSwapchainKHR?>

    init(width: UInt32, height: UInt32, device: VkDevice, surface: VkSurfaceKHR, buffers: UInt8) {
        var info = VkSwapchainCreateInfoKHR()
        info.sType = VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR
        info.surface = surface
        info.minImageCount = UInt32(buffers)
        info.presentMode = VK_PRESENT_MODE_MAILBOX_KHR
        info.imageFormat = VK_FORMAT_B8G8R8_UNORM 

        vkSwapchain = .allocate(capacity: 1)

        vkCreateSwapchainKHR(device, &info, nil, vkSwapchain)
    }

    func resize() {

    }

    func present() {

    }
}