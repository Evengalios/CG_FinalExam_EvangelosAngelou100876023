Shader "URP/LightingWithTransparency"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}  
        _MainTex_ST("Main Texture Tiling/Offset", Vector) = (1, 1, 0, 0)  
        _BaseColor("Base Color", Color) = (1, 1, 1, 1)  
    }

        SubShader
        {
            Tags { "RenderPipeline" = "UniversalRenderPipeline" "Queue" = "Transparent" "RenderType" = "Transparent" }
            Blend SrcAlpha OneMinusSrcAlpha  
            Pass
            {
                HLSLPROGRAM
                #pragma vertex vert
                #pragma fragment frag

                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

                struct Attributes
                {
                    float4 positionOS : POSITION;   
                    float2 uv : TEXCOORD0;        
                    float3 normalOS : NORMAL;     
                };

                struct Varyings
                {
                    float4 positionHCS : SV_POSITION;  
                    float2 uv : TEXCOORD0;            
                    float3 normalWS : TEXCOORD1;      
                };

 
                TEXTURE2D(_MainTex);
                SAMPLER(sampler_MainTex);

                float4 _BaseColor;
                CBUFFER_START(UnityPerMaterial)
                    float4 _MainTex_ST;
                CBUFFER_END

                    Varyings vert(Attributes IN)
                    {
                        Varyings OUT;
                        OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz); 
                        OUT.uv = TRANSFORM_TEX(IN.uv, _MainTex); 

                        OUT.normalWS = normalize(TransformObjectToWorldNormal(IN.normalOS));

                        return OUT;
                    }

                // Fragment Shader
                half4 frag(Varyings IN) : SV_Target
                {

                    Light mainLight = GetMainLight();
                    half3 lightDirWS = normalize(mainLight.direction);
                    half3 lightColor = mainLight.color;

                    // Lambertian diffuse lighting
                    half NdotL = max(0.0, dot(IN.normalWS, lightDirWS));
                    half3 diffuse = NdotL * lightColor;

                    // Sample the texture
                    half4 texColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv);

                    // Apply lighting to the texture's RGB, but keep the texture's alpha for transparency
                    half3 finalColor = texColor.rgb * _BaseColor.rgb * diffuse;

                    // Return the final color with the texture's alpha for transparency
                    return half4(finalColor, texColor.a);  // Preserve transparency from texture alpha
                }

                ENDHLSL
            }
        }}
