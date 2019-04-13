Shader "Hidden/PPGreyscale"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_BlendAmount("% Greyscale", Range(0, 1)) = 0
	}
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform float _BlendAmount;
			
			float4 frag(v2f_img i) : COLOR
			{
				float4 tex = tex2D(_MainTex, i.uv);

				// Constants represent human eye sensitivity to each colour.
				float lum = tex.r * 0.3 + tex.g * 0.59 + tex.b * 0.11;
				float3 gs = float3(lum, lum, lum);

				float4 result = tex;
				result.rgb = lerp(tex.rbg, gs, _BlendAmount);

				return result;
			}
			ENDCG
		}
	}
}
