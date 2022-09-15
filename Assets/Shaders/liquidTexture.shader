Shader "AlexAizatsky/liquidTexture"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _NoiseTex1 ("_NoiseTex1", 2D) = "white" {}
        _NoiseTex2 ("_NoiseTex2", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _HeightAmount ("Height Amount", float) = 0.5
       // _TessellationAmount ("Tessellation Amount", Range(1,32)) = 8
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
      #pragma surface surf Standard fullforwardshadows  vertex:vert
      /*
        #pragma surface surf Standard fullforwardshadows vertex:vert addshadow tessellate:tess nolightmap
        float _TessellationAmount;
        float tess()
        {
            return _TessellationAmount;
        }
        */
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.5

        sampler2D _NoiseTex1;
        sampler2D _NoiseTex2;
        struct Input
        {
            float2 uv_NoiseTex1;
            float2 uv_NoiseTex2;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        float _HeightAmount;
        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)
        void vert(inout appdata_full v)
        {
            float2 uvScroll = v.texcoord.xy + _Time.y * .1;
            float4 nts = tex2Dlod(_NoiseTex1, float4(uvScroll,0,0));
             float2 uvScroll2 = v.texcoord.xy - _Time.y * .3;
            float4 nts2 = tex2Dlod(_NoiseTex2, float4(uvScroll2,0,0));
            float ler = (nts.r+nts2.r)*0.5;
            v.vertex.y += v.normal.y * ler*_HeightAmount;
            
          //  float offset1 = tex2Dlod(_NoiseTex1, float4(v.texcoord.x, v.texcoord.y, 0, 0)).r * _HeightAmount;
          //  float offset2 = tex2Dlod(_NoiseTex2, float4(v.texcoord.x, v.texcoord.y, 0, 0)).r * _HeightAmount;
          //  float4 ve = float4(v.texcoord.x, v.texcoord.y, 0,1);
          //  float4 ver = mul(transpose(UNITY_MATRIX_IT_MV), ve);
          //  v.vertex.y -= ve.y;
        }
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 n = tex2D (_NoiseTex1, IN.uv_NoiseTex1) * _Color;
           fixed4 c = _Color;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
