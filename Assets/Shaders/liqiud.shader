Shader "AlexAizatsky/liqiud"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
         _Haos ("Haos", Range(0,1)) = 0
         _Height("Height",Range(0,5)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows  vertex:vert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.5

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 customColor;
            float _Haos;
            float _Height;
            fixed4 _Noise;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        float _Haos;
        float _Height;
        fixed4 _Noise;
        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void vert (inout appdata_full v, out Input o) {
          UNITY_INITIALIZE_OUTPUT(Input,o);
          o.customColor = v.normal;
          
          
           v.vertex.y += sin(cos( (v.vertex.z + v.vertex.x) * 6*_Height + _Time.y * 10)) *_Haos;
          
          
          
         //  v.texcoord = //в цвет запишем нормаль
        //  fixed4 c = tex2D (_MainTex, v.texcoord.xyz);
        //  v.vertex.y = v.vertex.y+c.r*_Haos*10;
        //  v.vertex.y += sin(cos((v.vertex.z*0.2f + v.vertex.y*0.2f)*30*_Time.y)) *_Haos*0.2;

       //   v.vertex.y +=sin(_Time.y*5) * _Flag;
       //   v.vertex.xyz += v.normal * sin(_Time.y)*0.5f; //выдавливаем по вертексу
                                                         //   v.vertex.y += sin(cos( (v.vertex.z + v.vertex.x) * 6*_Height + _Time.y * 10)) *_Haos; //движение вертексов по синусу
    //  v.vertex.y =  v.vertex.y* abs(sin(_Time.y*2));
     
      }


        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            _Noise = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = _Color.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = _Color.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
