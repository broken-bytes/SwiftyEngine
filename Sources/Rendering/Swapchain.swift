import Core
import Vulkan

class Swapchain {

    var vkSwapchain: VkSwapchainKHR?
    var imageFormat: VkFormat
    var images: UnsafeMutableBufferPointer<VkImage?>!
    var imageViews: UnsafeMutableBufferPointer<VkImageView?>!

    init(width: UInt32, height: UInt32, device: Device, surface: UnsafeMutablePointer<VkSurfaceKHR?>, buffers: UInt8, imageFormat: VkFormat) {
        let physicalDevice = device.physicalDevice
        guard let device = device.device.pointee else { 
            fatalError("Device is invalid")
        }
        var caps: UnsafeMutablePointer<VkSurfaceCapabilitiesKHR> = .allocate(capacity: 1)
        vkGetPhysicalDeviceSurfaceCapabilitiesKHR(physicalDevice, surface.pointee, caps)
        self.imageFormat = imageFormat
        var queueFamilyIndices: [UInt32] = [0]

        var info = VkSwapchainCreateInfoKHR()
        info.sType = VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR
        info.clipped = VK_TRUE
        info.compositeAlpha = VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR
        info.flags = 0
        info.imageColorSpace = VK_COLORSPACE_SRGB_NONLINEAR_KHR
        info.imageExtent.width = caps.pointee.currentExtent.width
        info.imageExtent.height = caps.pointee.currentExtent.height
        info.imageFormat = imageFormat
        info.imageArrayLayers = 1
        info.imageSharingMode = VK_SHARING_MODE_EXCLUSIVE
        info.imageUsage = 
            UInt32(VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT.rawValue |
            VK_IMAGE_USAGE_DEPTH_STENCIL_ATTACHMENT_BIT.rawValue
        )

        info.minImageCount = caps.pointee.minImageCount
        info.queueFamilyIndexCount = 1
        queueFamilyIndices.withUnsafeBufferPointer { 
            info.pQueueFamilyIndices = $0.baseAddress
        }
        info.presentMode = VK_PRESENT_MODE_IMMEDIATE_KHR
        info.preTransform = VK_SURFACE_TRANSFORM_IDENTITY_BIT_KHR 
        info.surface = surface.pointee

        withUnsafePointer(to: &info) {
            vkHandleSafe(vkCreateSwapchainKHR(device, $0, nil, &vkSwapchain))
        }

        var count: UInt32 = 0
        vkHandleSafe(vkGetSwapchainImagesKHR(device, vkSwapchain, &count, nil))

        images = .allocate(capacity: Int(count))
        imageViews = .allocate(capacity: Int(count))
        vkHandleSafe(vkGetSwapchainImagesKHR(device, vkSwapchain, &count, images.baseAddress))

        var index = 0
        for image in images {
            var ivInfo = VkImageViewCreateInfo()
            ivInfo.sType = VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO
            ivInfo.pNext = nil
            ivInfo.image = image
            ivInfo.format = imageFormat
            ivInfo.viewType = VK_IMAGE_VIEW_TYPE_2D

            vkHandleSafe(vkCreateImageView(device, &ivInfo, nil, imageViews.baseAddress?.advanced(by: index)))
            index += 1
        }
    }

    func resize() {

    }

    func present() {

    }

    func clear() {
    }
}