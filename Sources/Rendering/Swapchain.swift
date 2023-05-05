import Core
import Vulkan

class Swapchain {

    var vkSwapchain: VkSwapchainKHR? = nil
    var imageFormat: VkFormat
    var images: UnsafeMutableBufferPointer<VkImage?>!
    var imageViews: UnsafeMutableBufferPointer<VkImageView?>!

    init(width: UInt32, height: UInt32, device: Device, surface: UnsafeMutablePointer<VkSurfaceKHR?>, buffers: UInt8, imageFormat: VkFormat) {
        let physicalDevice = device.physicalDevice
        guard let device = device.device else { 
            log(level: .error, message: "Device is invalid")
            fatalError("Device is invalid")
        }
        var caps: UnsafeMutablePointer<VkSurfaceCapabilitiesKHR> = .allocate(capacity: 1)
        log(level: .info, message: "Will get caps")
        vkGetPhysicalDeviceSurfaceCapabilitiesKHR(physicalDevice, surface.pointee, caps)
        self.imageFormat = imageFormat
        
        let queueFamilyIndices: UnsafeMutablePointer<UInt32> = .allocate(capacity: 1)
        queueFamilyIndices.initialize(to: 0)

        log(level: .info, message: "Will get queues")

        var info = VkSwapchainCreateInfoKHR(
            sType: VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR, 
            pNext: nil, 
            flags: 0, 
            surface: surface.pointee, 
            minImageCount: caps.pointee.minImageCount, 
            imageFormat: imageFormat, 
            imageColorSpace: VK_COLORSPACE_SRGB_NONLINEAR_KHR, 
            imageExtent: VkExtent2D(width: caps.pointee.currentExtent.width, height: caps.pointee.currentExtent.height), 
            imageArrayLayers: 1, 
            imageUsage: UInt32(
                VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT.rawValue
            ), 
            imageSharingMode: VK_SHARING_MODE_EXCLUSIVE, 
            queueFamilyIndexCount: 1, 
            pQueueFamilyIndices: queueFamilyIndices, 
            preTransform: VK_SURFACE_TRANSFORM_IDENTITY_BIT_KHR, 
            compositeAlpha: VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR, 
            presentMode: VK_PRESENT_MODE_IMMEDIATE_KHR, 
            clipped: VK_TRUE, 
            oldSwapchain: nil
        )
        
        log(level: .info, message: "Will create swapchain")

        vkHandleSafe(vkCreateSwapchainKHR(device, &info, nil, &vkSwapchain))
        log(level: .info, message: "Will get swapchain images")

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

            log(level: .info, message: "Will create swapchain image view")
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