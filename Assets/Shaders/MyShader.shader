   Shader "AlexAizatsky/Custom Vertex Data" {
    Properties {
    	_Color ("Main Color", Color) = (1,1,1,1)
	   _SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
	   _Shininess ("Shininess", Range (0.03, 1)) = 0.078125
      _MainTex ("Texture", 2D) = "white" {}
      _BumpMap ("Normalmap", 2D) = "bump" {}
      
         _GlossMapScale ("Smoothness", Range(0.0, 1.0)) = 0.0
        _MetallicFactor("Metallic Factor", Range(0.0, 1.0)) = 0
        _MetallicGlossMap ("Metallic", 2D) = "gloss" {}
        [ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
      
      _Contrast ("Contrast", Range(0,20)) = 0
      _Haos ("Haos", Range(0,1)) = 0
      _Clamb ("Clamb", Range(1,30)) = 1
      _Flag ("Flag", Range(0,1)) = 0
    }
    SubShader {
      Tags { "RenderType" = "Opaque" }

      CGPROGRAM
      #pragma surface surf BlinnPhong vertex:vert //указываем, что есть вертексный шейдер и он называется vert
      #pragma shader_feature _SPECULARHIGHLIGHTS_OFF
      //входящяя структура для сюрфейсного шейдера 
      struct Input {
          float2 uv_MainTex;
          float2 uv_BumpMap;
          float3 customColor;
          float _Haos;
          float3 viewDir;
          float3 worldNormal; //добавляет мировую нормаль
      };
       float _Haos;
       float _Flag;
      //Вертексный шейдер
      void vert (inout appdata_full v, out Input o) {
          UNITY_INITIALIZE_OUTPUT(Input,o);
          o.customColor = v.normal; //в цвет запишем нормаль

          v.vertex.y += sin(cos((v.vertex.z + v.vertex.y)*10*_Time.y)) *_Haos*0.5;

       //   v.vertex.y +=sin(_Time.y*5) * _Flag;
       //   v.vertex.xyz += v.normal * sin(_Time.y)*0.5f; //выдавливаем по вертексу
      //     v.vertex.y += sin( v.vertex.x * 6 + _Time.y * 10) * 0.1; //движение вертексов по синусу
    //  v.vertex.y =  v.vertex.y* abs(sin(_Time.y*2));
     
      }


      //Сюрфейсный шейдер
      sampler2D _MainTex;
      sampler2D _BumpMap;
      fixed4 _Color;
      half _Shininess;
      float _Contrast;
     float _Clamb;
     
     sampler2D _MetallicGlossMap;
        
        half _GlossMapScale;
        half _MetallicFactor;
      void surf (Input IN, inout SurfaceOutput o) 
      {
      
      fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	  o.Albedo = tex.rgb * _Color.rgb;
  	  o.Gloss = tex.a;
	  o.Alpha = tex.a * _Color.a;
	  /*
	   half rim = _RimCap - saturate(dot(normalize(IN.viewDir), o.Normal));
            o.Emission = _RimColor.rgb * pow(rim, _RimIntensity);
            
            fixed4 metal_colour = tex2D(_MetallicGlossMap, IN.uv_MainTex);
            o.Metallic = metal_colour.r * _MetallicFactor;
            o.Smoothness = metal_colour.a * _GlossMapScale;
            */
	  o.Specular = _Shininess;
	  o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
/*
      float3 myCol = tex2D (_MainTex, IN.uv_MainTex).rgb;
      float3 wNorm = IN.worldNormal;
     
   
   if (myCol.r < 0.33)
   {
   myCol.r = 0;
   }
    if (myCol.r >= 0.33 && myCol.r < 0.66)
   {
   myCol.r = 0.5;
   }
    if (myCol.r >= 0.66)
   {
   myCol.r = 1;
   }
    if (myCol.g < 0.33)
   {
   myCol.g = 0;
   }
    if (myCol.g >= 0.33 && myCol.g < 0.66)
   {
   myCol.g = 0.5;
   }
    if (myCol.g >= 0.66)
   {
   myCol.g = 1;
   }
    if (myCol.b < 0.33)
   {
   myCol.b = 0;
   }
    if (myCol.b >= 0.33 && myCol.b < 0.66)
   {
   myCol.b = 0.5;
   }
    if (myCol.b >= 0.66)
   {
   myCol.b = 1;
   }
   
   int r = myCol.r*_Clamb;
   int g = myCol.g*_Clamb;
   int b = myCol.b *_Clamb;
   myCol.r = r/_Clamb;
   myCol.g = g/_Clamb;
   myCol.b = b/_Clamb;
         o.Albedo = myCol;
*/
 
           //     o.Albedo = myCol*(1- pow(wNorm.y, _Contrast)) + float3(1,1,1)* pow(wNorm.y, _Contrast);
          //o.Albedo = IN.customColor;
         // o.Albedo = IN.worldNormal;
      }
      ENDCG
    } 
    Fallback "Diffuse"
  }