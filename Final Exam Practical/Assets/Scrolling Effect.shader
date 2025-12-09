Shader "URP/ScrollEffect_Evangelos"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
        _Color1("Color 1", Color) = (1, 0.3, 0, 1)
        _MoveSpeed("Move Speed", Range(0, 2)) = 0.5
        _EmissionStrength("Emission Strength", Range(0, 5)) = 2.0
        _TextureScale("Texture Scale", Float) = 1.0
    }

        SubShader
        {
            Tags { "RenderPipeline" = "UniversalPipeline" "RenderType" = "Opaque" }

            Pass
            {
                HLSLPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

                struct Attributes
                {
                    float4 positionOS : POSITION;
                    float2 uv : TEXCOORD0;
                };

                struct Varyings
                {
                    float4 positionHCS : SV_POSITION;
                    float2 uv : TEXCOORD0;
                };

                TEXTURE2D(_MainTex);
                SAMPLER(sampler_MainTex);

                CBUFFER_START(UnityPerMaterial)
                    float4 _Color1;
                    float _MoveSpeed;
                    float _EmissionStrength;
                    float _TextureScale;
                    float4 _MainTex_ST;
                CBUFFER_END

                Varyings vert(Attributes v)
                {
                    Varyings o;
                    o.positionHCS = TransformObjectToHClip(v.positionOS.xyz);
                    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                    return o;
                }

                half4 frag(Varyings i) : SV_Target
                {

                    if (_TextureScale < 0.001)
                        return half4(0.2, 0.2, 0.2, 1.0);

                float2 scrolledUV = i.uv * _TextureScale;
                scrolledUV.y += _Time.y * _MoveSpeed;

                half4 texColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, scrolledUV);

                half3 finalColor = texColor.rgb * _Color1.rgb * _EmissionStrength;

                return half4(finalColor, 1.0);
            }

            ENDHLSL
        }
        }
}