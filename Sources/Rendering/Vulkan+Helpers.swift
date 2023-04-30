import Vulkan

internal func vkHandleSafe(_ result: VkResult, file: String = #file, function: String = #function, line: Int = #line) -> Void {
    if(result != VK_SUCCESS) {
        fatalError("Failed to execute vulkan function\nError: \(result.rawValue)\n\(file):\(function):\(line)")
    }
}