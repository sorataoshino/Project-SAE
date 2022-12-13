Shader "Toon/Lit Dissolve Appear" {
    Properties {
        _Color ("Main Color", Color) = (0.5,0.5,0.5,1)
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _Ramp ("Toon Ramp (RGB)", 2D) = "gray" {}
        _NoiseTex("Dissolve Noise", 2D) = "white"{} 
        _NScale ("Noise Scale", Range(0, 10)) = 1 
        _DisAmount("Noise Texture Opacity", Range(0.01, 1)) = 0 
        _DisLineWidth("Line Width", Range(0, 2)) = 0 
        _DisLineColor("Line Tint", Color) = (1,1,1,1)           
        [Toggle(ALPHA)] _ALPHA("Transparent", Float) = 0
    }

        SubShader{
            Tags { "RenderType" = "Transparent" }
            LOD 200
 
        Blend SrcAlpha OneMinusSrcAlpha //transparency
CGPROGRAM
 
#pragma shader_feature LIGHTMAP
#pragma surface surf Lambert alphatest:_ALPHA addshadow//transparency
 
uniform float3 _Position;
uniform float _Radius;
 
sampler2D _MainTex;
float4 _Color;
sampler2D _NoiseTex;
float _DisAmount, _NScale;
float _DisLineWidth;
float4 _DisLineColor;
 
 
struct Input {
    float2 uv_MainTex : TEXCOORD0;
    float3 worldPos;
	float3 worldNormal;
};
 
void surf (Input IN, inout SurfaceOutput o) {
    half4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
 
    //triplanar noise
	float3 blendNormal = saturate(pow(IN.worldNormal * 1.4,4));
    half4 nSide1 = tex2D(_NoiseTex, (IN.worldPos.xy + _Time.x) * _NScale); 
	half4 nSide2 = tex2D(_NoiseTex, (IN.worldPos.xz + _Time.x) * _NScale);
	half4 nTop = tex2D(_NoiseTex, (IN.worldPos.yz + _Time.x) * _NScale);
 
	float3 noisetexture = nSide1;
    noisetexture = lerp(noisetexture, nTop, blendNormal.x);
    noisetexture = lerp(noisetexture, nSide2, blendNormal.y);
 
	// distance influencer position to world position and sphere radius
	float3 dis = distance(_Position, IN.worldPos);
	float3 sphereR = 1 - saturate(dis / _Radius);
 
	float3 sphereRNoise = noisetexture * sphereR.r;
 
	float3 DissolveLineIn = step(sphereRNoise- _DisLineWidth, _DisAmount);
 
    float3 NoDissolve = float3(1, 1, 1) - DissolveLineIn ;
    c.rgb = (DissolveLineIn * _DisLineColor) + (NoDissolve * c.rgb);
    o.Emission =  (DissolveLineIn * _DisLineColor) * 2;
    c.a = step(_DisAmount, sphereRNoise);
    o.Albedo = c.rgb;
    o.Alpha = c.a;
}
ENDCG
    }
    Fallback "Diffuse"
}