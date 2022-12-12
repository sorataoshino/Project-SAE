Shader "ColorFilter/Unlit/GlowBall"
{
    Properties
    {
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        LOD 100

        BlendOp Max
        ZWrite Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL0;
            };

            struct v2f
            {
                float3 normal : TEXCOORD0;
                float3 view : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };
    
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = mul(UNITY_MATRIX_IT_MV, v.normal);
                o.view = -UnityObjectToViewPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float fresnel = saturate(dot(normalize(i.normal), normalize(i.view)));
                return float4(0, 0, 0, fresnel * fresnel);
            }
            ENDCG
        }
    }
}