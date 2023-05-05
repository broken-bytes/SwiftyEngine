import Vulkan

class PipelineStage {

    private var vsMain: UnsafePointer<Int8>!
    private var psMain: UnsafePointer<Int8>!
    var stages: [VkPipelineShaderStageCreateInfo] = []

    init(vertexShader: Shader, pixelShader: Shader) {
        "VSMain".withCString {
            let vsMainPtr: UnsafeMutableRawPointer = .allocate(byteCount: strlen($0) + 1, alignment: 1)
            memcpy(vsMainPtr, $0, strlen($0))
            vsMain = UnsafePointer(vsMainPtr.assumingMemoryBound(to: Int8.self))
        }

        "PSMain".withCString {
            let psMainPtr: UnsafeMutableRawPointer = .allocate(byteCount: strlen($0) + 1, alignment: 1)
            memcpy(psMainPtr, $0, strlen($0))
            psMain = UnsafePointer(psMainPtr.assumingMemoryBound(to: Int8.self))
        }

        let vertexShaderStageInfo = VkPipelineShaderStageCreateInfo(
            sType: VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO, 
            pNext: nil, 
            flags: 0, 
            stage: VK_SHADER_STAGE_VERTEX_BIT, 
            module: vertexShader.module, 
            pName: vsMain, 
            pSpecializationInfo: nil
        )
        let pixelShaderStageInfo = VkPipelineShaderStageCreateInfo(
            sType: VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO, 
            pNext: nil, 
            flags: 0, 
            stage: VK_SHADER_STAGE_FRAGMENT_BIT, 
            module: pixelShader.module, 
            pName: psMain, 
            pSpecializationInfo: nil
        )   

        stages.append(vertexShaderStageInfo)
        stages.append(pixelShaderStageInfo)
    }
}