Shader "Hidden/PPSobelEdge"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_DeltaX("Delta X", Float) = 0.01
		_DeltaY("Delta Y", Float) = 0.01
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }

		CGINCLUDE

		#include "UnityCG.cginc"

		uniform sampler2D _MainTex;
		uniform float _DeltaX;
		uniform float _DeltaY;

		float sobel(sampler2D tex, float2 uv)
		{
			float2 delta = float2(_DeltaX, _DeltaY);
			float4 h = float4 (0, 0, 0, 0);
			float4 v = float4 (0, 0, 0, 0);

			h += tex2D(tex, (uv + float2(-1.0, -1.0) * delta)) *  1.0;
			//h += tex2D(tex, (uv + float2( 0.0, -1.0) * delta)) *  0.0;
			h += tex2D(tex, (uv + float2( 1.0, -1.0) * delta)) * -1.0;
			h += tex2D(tex, (uv + float2(-1.0,  0.0) * delta)) *  2.0;
			//h += tex2D(tex, (uv + float2( 0.0,  0.0) * delta)) *  0.0;
			h += tex2D(tex, (uv + float2( 1.0,  0.0) * delta)) * -2.0;
			h += tex2D(tex, (uv + float2(-1.0,  1.0) * delta)) *  1.0;
			//h += tex2D(tex, (uv + float2( 0.0,  1.0) * delta)) *  0.0;
			h += tex2D(tex, (uv + float2( 1.0,  1.0) * delta)) * -1.0;

			v += tex2D(tex, (uv + float2(-1.0, -1.0) * delta)) *  1.0;
			v += tex2D(tex, (uv + float2( 0.0, -1.0) * delta)) *  2.0;
			v += tex2D(tex, (uv + float2( 1.0, -1.0) * delta)) *  1.0;
			//v += tex2D(tex, (uv + float2(-1.0,  0.0) * delta)) *  0.0;
			//v += tex2D(tex, (uv + float2( 0.0,  0.0) * delta)) *  0.0;
			//v += tex2D(tex, (uv + float2( 1.0,  0.0) * delta)) *  0.0;
			v += tex2D(tex, (uv + float2(-1.0,  1.0) * delta)) * -1.0;
			v += tex2D(tex, (uv + float2( 0.0,  1.0) * delta)) * -2.0;
			v += tex2D(tex, (uv + float2( 1.0,  1.0) * delta)) * -1.0;

			return sqrt(h * h + v * v);
		}

		float4 frag (v2f_img i) : COLOR
		{
			float s = sobel(_MainTex, i.uv);
			return float4(s, s, s, 1);
		}

		ENDCG

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			ENDCG
		}
	}
}
