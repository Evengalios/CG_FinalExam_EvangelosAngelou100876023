Shader "URP/Hologram"
{
    Properties
    {
        _MainColor("Main Color", Color) = (0, 1, 1, 1)
        _SecondaryColor("Secondary Color", Color) = (0, 0.5, 1, 1)
        _WaveSpeed("Wave Speed", Range(0, 5)) = 1
        _WaveFrequency("Wave Frequency", Range(1, 10)) = 3
        _EmissionStrength("Emission Strength", Range(0, 10)) = 2
        _Rim("Rim Power", Range(0, 5)) = 2
    }

        SubShader
    {
        Tags
        {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
            "RenderPipeline" = "UniversalPipeline"
        }

        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off
        Cull Off

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
                float3 normalWS : TEXCOORD0;
                float3 viewDirWS : TEXCOORD1;
                float2 uv : TEXCOORD2;
                float3 positionWS : TEXCOORD3;
            };

            CBUFFER_START(UnityPerMaterial)
                float4 _MainColor;
                float4 _SecondaryColor;
                float _WaveSpeed;
                float _WaveFrequency;
                float _EmissionStrength;
                float _Rim;
            CBUFFER_END

            Varyings vert(Attributes IN)
            {
                Varyings OUT;

                VertexPositionInputs posInputs = GetVertexPositionInputs(IN.positionOS.xyz);
                OUT.positionHCS = posInputs.positionCS;
                OUT.positionWS = posInputs.positionWS;

                VertexNormalInputs normInputs = GetVertexNormalInputs(IN.normalOS);
                OUT.normalWS = normInputs.normalWS;

                OUT.viewDirWS = GetWorldSpaceViewDir(posInputs.positionWS);
                OUT.uv = IN.uv;

                return OUT;
            }

            float4 frag(Varyings IN) : SV_Target
            {
                float3 normalWS = normalize(IN.normalWS);
                float3 viewDirWS = normalize(IN.viewDirWS);

                float rim = pow(1.0 - saturate(dot(normalWS, viewDirWS)), _Rim); //rim lighting


                float wave = sin((IN.uv.y * _WaveFrequency + _Time.y * _WaveSpeed) * 6.28318);
                wave = wave * 0.5 + 0.5; //Sine wave for wave

                float3 color = lerp(_SecondaryColor.rgb, _MainColor.rgb, wave); //lerping both colors
                color *= rim; 
                float3 emission = color * _EmissionStrength;

                float alpha = rim * (wave * 0.3 + 0.3) * _MainColor.a; 

                return float4(emission, alpha);
            }
            ENDHLSL
        }
    }
}