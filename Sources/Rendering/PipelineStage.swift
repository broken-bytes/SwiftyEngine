import Vulkan

class PipelineStage {

    var stages: [VkPipelineShaderStageCreateInfo] = []

    init(vertexShader: Shader, pixelShader: Shader) {
        var vertexShaderStageInfo = VkPipelineShaderStageCreateInfo()
        vertexShaderStageInfo.sType = VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO
        vertexShaderStageInfo.stage = VK_SHADER_STAGE_VERTEX_BIT
        vertexShaderStageInfo.module = vertexShader.module
        "VSMain".withCString {
            vertexShaderStageInfo.pName = $0
        }

        var pixelShaderStageInfo = VkPipelineShaderStageCreateInfo()
        pixelShaderStageInfo.sType = VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO
        pixelShaderStageInfo.stage = VK_SHADER_STAGE_FRAGMENT_BIT
        pixelShaderStageInfo.module = pixelShader.module
        "PSMain".withCString {
            pixelShaderStageInfo.pName = $0
        }

        stages.append(vertexShaderStageInfo)
        stages.append(pixelShaderStageInfo)
    }
}