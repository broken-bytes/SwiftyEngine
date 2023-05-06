import Core
import Vulkan

class Swapchain {

    var vkSwapchain: VkSwapchainKHR? = nil
    var imageFormat: VkFormat
    var images: UnsafeMutableBufferPointer<VkImage?>!
    var imageViews: UnsafeMutableBufferPointer<VkImageView?>!

    init(width: UInt32, height: UInt32, device: Device, surface: UnsafeMutablePointer<VkSurfaceKHR?>, buffers: UInt8, imageFormat: VkFormat) {
        
        var imageCaps: UnsafeMutablePointer<VkImageFormatProperties> = .allocate(capacity: 1)

        vkHandleSafe(vkGetPhysicalDeviceImageFormatProperties(device.physicalDevice, imageFormat, VK_IMAGE_TYPE_2D, VK_IMAGE_TILING_OPTIMAL, UInt32(VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT.rawValue), 0, imageCaps))
        let physicalDevice = device.physicalDevice
        guard let device = device.device else { 
            log(level: .error, message: "Device is invalid")
            fatalError("Device is invalid")
        }
        var caps: UnsafeMutablePointer<VkSurfaceCapabilitiesKHR> = .allocate(capacity: 1)
        vkHandleSafe(vkGetPhysicalDeviceSurfaceCapabilitiesKHR(physicalDevice, surface.pointee, caps))

        self.imageFormat = imageFormat
        
        let queueFamilyIndices: UnsafeMutablePointer<UInt32> = .allocate(capacity: 1)
        queueFamilyIndices.initialize(to: 0)

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
        
        vkHandleSafe(vkCreateSwapchainKHR(device, &info, nil, &vkSwapchain))

        var count: UInt32 = 0
        vkHandleSafe(vkGetSwapchainImagesKHR(device, vkSwapchain, &count, nil))

        images = .allocate(capacity: Int(count))
        imageViews = .allocate(capacity: Int(count))
        vkHandleSafe(vkGetSwapchainImagesKHR(device, vkSwapchain, &count, images.baseAddress))

        var index = 0
        for image in images {
            var ivInfo = VkImageViewCreateInfo(
                sType: VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO, 
                pNext: nil, 
                flags: 0, 
                image: image, 
                viewType: VK_IMAGE_VIEW_TYPE_2D, 
                format: imageFormat, 
                components: VkComponentMapping(
                    r: VkComponentSwizzle(VK_COMPONENT_SWIZZLE_IDENTITY.rawValue), 
                    g: VkComponentSwizzle(VK_COMPONENT_SWIZZLE_IDENTITY.rawValue), 
                    b: VkComponentSwizzle(VK_COMPONENT_SWIZZLE_IDENTITY.rawValue), 
                    a: VkComponentSwizzle(VK_COMPONENT_SWIZZLE_IDENTITY.rawValue)
                ), 
                subresourceRange: VkImageSubresourceRange(
                    aspectMask: UInt32(VK_IMAGE_ASPECT_COLOR_BIT.rawValue), 
                    baseMipLevel: 0, 
                    levelCount: 1, 
                    baseArrayLayer: 0, 
                    layerCount: 1
                )
            )

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