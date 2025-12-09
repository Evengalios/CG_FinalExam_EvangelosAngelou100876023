Shader "URP/RimLighting_Evangelos"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Color("Base Color", Color) = (1, 1, 1, 1)
        _RimColor("Rim Color", Color) = (0, 0.5, 1, 1)
        _RimPower("Rim Power", Range(0.5, 8.0)) = 3.0
    }

        SubShader
        {
            Tags
            {
                "RenderPipeline" = "UniversalPipeline"
                "RenderType" = "Opaque"
            }

            Pass
            {
                HLSLPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

                struct Attributes
                {
                    float4 positionOS : POSITION;
                    float3 normalOS : NORMAL;
                    float2 uv : TEXCOORD0;
                };

                struct Varyings
                {
                    float4 positionHCS : SV_POSITION;
                    float2 uv : TEXCOORD0;
                    float3 normalWS : TEXCOORD1;
                    float3 viewDirWS : TEXCOORD2;
                };

                TEXTURE2D(_MainTex);
                SAMPLER(sampler_MainTex);

                CBUFFER_START(UnityPerMaterial)
                    float4 _Color;
                    float4 _RimColor;
                    float _RimPower;
                    float4 _MainTex_ST;
                CBUFFER_END

                Varyings vert(Attributes v)
                {
                    Varyings o;
                    o.positionHCS = TransformObjectToHClip(v.positionOS.xyz);
                    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                    o.normalWS = TransformObjectToWorldNormal(v.normalOS);

                    float3 worldPos = TransformObjectToWorld(v.positionOS.xyz);
                    o.viewDirWS = normalize(GetCameraPositionWS() - worldPos);

                    return o;
                }

                half4 frag(Varyings i) : SV_Target
                {
                    half4 texColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv);
                    half3 baseColor = texColor.rgb * _Color.rgb;

           
                    float3 normalWS = normalize(i.normalWS);
                    float3 viewDir = normalize(i.viewDirWS);

                    float rimFactor = 1.0 - saturate(dot(viewDir, normalWS));
                    float rim = pow(rimFactor, _RimPower);

                    half3 finalColor = baseColor + (_RimColor.rgb * rim);

                    return half4(finalColor, 1.0);
                }

                ENDHLSL
            }
        }
}
