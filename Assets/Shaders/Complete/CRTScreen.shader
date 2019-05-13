Shader "SMO2/Complete/CRTScreen"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Brightness("Brightness", Float) = 0
		_Contrast("Contrast", Float) = 0
	}
	SubShader
	{
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 screenPos: TEXCOORD1;
			};

			v2f vert (appdata_img v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.screenPos = ComputeScreenPos(o.vertex);
				o.uv = v.texcoord;
				return o;
			}
			
			sampler2D _MainTex;
			float _Brightness;
			float _Contrast;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
			
				fixed2 sp = i.screenPos.xy * _ScreenParams.xy;

				float3 r = float3(col.r,     col.g / 4, col.b / 4);
				float3 g = float3(col.r / 4, col.g,     col.b / 4);
				float3 b = float3(col.r / 4, col.g / 4, col.b);
				float3x3 colormap = float3x3(r, g, b);

				float3 wh = 1.0;
				float3 bl = 0.0;

				float3x3 scanlineMap = float3x3(wh, wh, bl);

				fixed3 returnVal = colormap[(int)sp.x % 3] * scanlineMap[(int)sp.y % 3];

				returnVal += (_Brightness / 255);
				returnVal = saturate(returnVal);
				returnVal = returnVal - _Contrast * (returnVal - 1.0) * returnVal * (returnVal - 0.5);

				return fixed4(returnVal, 1.0);
			}
			ENDCG
		}
	}
}
