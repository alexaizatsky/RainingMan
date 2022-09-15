Shader "Doctrina/Water" {
Properties {
	_SpecColor ("Specular Color", Color) = (0.5,0.5,0.5,1)
	_Shininess ("Shininess", Range (0.01, 1)) = 0.078125
	_RefractionDistort ("Refraction distort", Range (0.00, 100.0)) = 0.1
	_ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
	_DepthColor ("Depth Color", Color) = (1,1,1,0.5)
	_ReflectionTex ("ReflectionTex", 2D) = "white" {}
	_BumpMap ("Normalmap", 2D) = "bump" {}
	_FPOW("FPOW", Float) = 5.0
	_R0("R0", Float) = 0.05
}

SubShader 
{	
	
	Tags { "RenderType"="Transparent" }
	LOD 100
	
	GrabPass 
	{ 
		
	}
	
CGPROGRAM

#pragma surface surf BlinnPhong alpha
#pragma target 3.0

sampler2D _GrabTexture;
sampler2D _BumpMap;
sampler2D _ReflectionTex;

sampler2D _CameraDepthTexture;

float4 _ReflectColor;
float4 _DepthColor;
float _Shininess;
float _RefractionDistort;
float _FPOW;
float _R0;

float4 _GrabTexture_TexelSize;
float4 _CameraDepthTexture_TexelSize;

struct Input {
	float2 uv_MainTex;
	float2 uv_BumpMap;
	float3 worldRefl; 
	float4 screenPos;
	float3 viewDir;
	INTERNAL_DATA
};

void surf (Input IN, inout SurfaceOutput o) 
{ 
	o.Gloss = _SpecColor.a;
	o.Specular = _Shininess;

	float depth = SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(IN.screenPos));
	depth = LinearEyeDepth(depth);
	float beachAlpha = saturate( 1 * (depth-IN.screenPos.w) ).x;

	//Normal 
	o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap + float2( _Time.x * 0.5,0 )  ));
	o.Normal += UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap * 2 + float2( 0,_Time.x * 0.5 ) ));
	o.Normal *= 0.5;

    float2 ofs = o.Normal * _RefractionDistort * beachAlpha;
    IN.screenPos.xy = ofs * IN.screenPos.z + IN.screenPos.xy;	
	
	half4 reflcol = tex2Dproj(_ReflectionTex, IN.screenPos);
	reflcol = reflcol * _ReflectColor;
	
	float3 refrColor = tex2Dproj(_GrabTexture, IN.screenPos);
	refrColor = _DepthColor * refrColor ;

	o.Alpha = clamp( beachAlpha, 0, 1 );
   // o.Alpha = 1;
	
	//Freshel 
	half fresnel = saturate( 1.0 - dot(o.Normal, normalize(IN.viewDir)) );
	fresnel = pow(fresnel, _FPOW);
	fresnel =  _R0 + (1.0 - _R0) * fresnel;
	
	half4 resCol = reflcol * fresnel + half4( refrColor.xyz,1.0) * ( 1.0 - fresnel);	
  
    o.Emission = resCol;
	o.Albedo = resCol;

}
ENDCG
}

FallBack "Reflective/Bumped Diffuse"
}
