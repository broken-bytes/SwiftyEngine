import Core
import Vulkan

#if os(Windows)
import WinSDK

internal func vkHandleSafe(_ result: VkResult, file: String = #file, function: String = #function, line: Int = #line) -> Void {
    if(result != VK_SUCCESS) {
        OutputDebugStringA("Failed to execute vulkan function\nError: \(result.rawValue)\n\(file):\(function):\(line)")
        MessageBoxA(nil, "Vulkan Error", "Failed to execute vulkan function\nError: \(result.rawValue)\n\(file):\(function):\(line)", 0)
        log(level: .error, message: "Failed to execute vulkan function\nError: \(result.rawValue)\n\(file):\(function):\(line)")
        fatalError("Failed to execute vulkan function\nError: \(result.rawValue)\n\(file):\(function):\(line)")
    }
}

#else
internal func vkHandleSafe(_ result: VkResult, file: String = #file, function: String = #function, line: Int = #line) -> Void {
    if(result != VK_SUCCESS) {
        log(level: .error, message: "Failed to execute vulkan function\nError: \(result.rawValue)\n\(file):\(function):\(line)")
        fatalError("Failed to execute vulkan function\nError: \(result.rawValue)\n\(file):\(function):\(line)")
    }
}
#endif