struct VSOutput {
    float4 Position : SV_POSITION;
    float4 Color : COLOR0;
};

float4 PSMain(VSOutput output) : SV_TARGET {
    return float4(output.Color);
}
