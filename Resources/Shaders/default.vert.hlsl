struct VSInput
{
	float3 Position : POSITION0;
    float2 UV : TEXCOORD0;
    float4 Color : COLOR0;
};

struct UBO
{
	float4x4 projectionMatrix;
	float4x4 modelMatrix;
	float4x4 viewMatrix;
};

cbuffer ubo : register(b0, space0) { UBO ubo; }

struct VSOutput
{
	float4 Position : SV_POSITION;
    float4 Color : COLOR0;
};

VSOutput VSMain(VSInput input, uint VertexIndex : SV_VertexID)
{
	VSOutput output = (VSOutput)0;
	output.Color = input.Color * float(VertexIndex) * input.UV.xyxy;
	output.Position = mul(
		ubo.projectionMatrix, 
		mul(
			ubo.viewMatrix, 
			mul(
				ubo.modelMatrix, 
				float4(input.Position.xyz, 1.0)
			)
		)
	);
	return output;
}