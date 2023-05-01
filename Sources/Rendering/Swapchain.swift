import Core
import Vulkan

class Swapchain {

    var vkSwapchain: UnsafeMutablePointer<VkSwapchainKHR?>

    init(width: UInt32, height: UInt32, device: Device, surface: UnsafeMutablePointer<VkSurfaceKHR?>, buffers: UInt8) {
        let physicalDevice = device.physicalDevice
        guard let device = device.device.pointee else { 
            fatalError("Device is invalid")
        }
        var caps: UnsafeMutablePointer<VkSurfaceCapabilitiesKHR> = .allocate(capacity: 1)
        vkGetPhysicalDeviceSurfaceCapabilitiesKHR(physicalDevice, surface.pointee, caps)

        var queueFamilyIndices: [UInt32] = [0]

        var info = VkSwapchainCreateInfoKHR()
        info.sType = VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR
        info.clipped = VK_TRUE
        info.compositeAlpha = VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR
        info.flags = 0
        info.imageColorSpace = VK_COLORSPACE_SRGB_NONLINEAR_KHR
        info.imageExtent.width = caps.pointee.currentExtent.width
        info.imageExtent.height = caps.pointee.currentExtent.height
        info.imageFormat = VK_FORMAT_B8G8R8A8_SRGB
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

        vkSwapchain = .allocate(capacity: 1)

        withUnsafePointer(to: &info) {
            vkHandleSafe(vkCreateSwapchainKHR(device, $0, nil, vkSwapchain))
        }
    }

    func resize() {

    }

    func present() {

    }
}