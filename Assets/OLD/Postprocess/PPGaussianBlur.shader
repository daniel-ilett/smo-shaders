Shader "Custom/PPGaussianBlur"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
		
	CGINCLUDE
	
	#include "UnityCG.cginc"

	struct appdata_t
	{
		float4 pos : POSITION;
		float2 uv : TEXCOORD0;
	};

	struct v2f
	{
		float4 pos : SV_POSITION;
		float2 uv : TEXCOORD0;
	};

	struct out_fivetap
	{
		float4 pos : SV_POSITION;
		float2 uv : TEXCOORD0;
		float4 blurUV : TEXCOORD1;
	};

	struct out_ninetap
	{
		float4 pos : SV_POSITION;
		float2 uv : TEXCOORD0;
		float4 blurUV[2] : TEXCOORD1;
	};

	struct out_thirteentap
	{
		float4 pos : SV_POSITION;
		float2 uv : TEXCOORD0;
		float4 blurUV[3] : TEXCOORD1;
	};

	uniform sampler2D _MainTex;
	uniform float4 _MainTex_ST;
	uniform float2 _MainTex_TexelSize;

	uniform float _Radius;

	v2f vert(appdata_t i)
	{
		v2f o;

		o.pos = UnityObjectToClipPos(i.pos);
		o.uv = i.uv;

		return o;
	}

	fixed4 frag (v2f i) : SV_Target
	{
		fixed3 col = tex2D(_MainTex, i.uv);
		return fixed4(col, 1.0);
	}

	// Small kernel for Gaussian blur. Offset defines direction (horizontal/vertical).
	out_fivetap vert_fivetap(v2f i, float2 offset)
	{
		out_fivetap o;

		o.pos = UnityObjectToClipPos(i.pos);

		float2 uv = UnityStereoScreenSpaceUVAdjust(i.uv, _MainTex_ST);

		o.uv = uv;
		o.blurUV.xy = uv + offset;
		o.blurUV.zw = uv - offset;

		return o;
	}

	out_fivetap vert_fivetap_h(v2f i)
	{
		return vert_fivetap(i, float2(_MainTex_TexelSize.x * _Radius * 1.33333333, 0.0));
	}

	out_fivetap vert_fivetap_v(v2f i)
	{
		return vert_fivetap(i, float2(0.0, _MainTex_TexelSize.y * _Radius * 1.33333333));
	}

	fixed4 frag_fivetap(out_fivetap i) : SV_Target
	{
#if GAMMA_CORRECTION
		fixed3 sum = GammaToLinearSpace(tex2D(_MainTex, i.uv).xyz) * 0.29411764;
		sum += GammaToLinearSpace(tex2D(_MainTex, i.blurUV.xy).xyz) * 0.35294117;
		sum += GammaToLinearSpace(tex2D(_MainTex, i.blurUV.zw).xyz) * 0.35294117;
		return fixed4(LinearToGammaSpace(sum), 1.0);
#else
		fixed3 sum = tex2D(_MainTex, i.uv).xyz * 0.29411764;
		sum += tex2D(_MainTex, i.blurUV.xy).xyz * 0.35294117;
		sum += tex2D(_MainTex, i.blurUV.zw).xyz * 0.35294117;
		return fixed4(sum, 1.0);
#endif
	}

	// Medium kernel for Gaussian blur. Offset defines direction (horizontal/vertical).
	out_ninetap vert_ninetap(v2f i, float2 offset1, float2 offset2)
	{
		out_ninetap o;

		o.pos = UnityObjectToClipPos(i.pos);

		float2 uv = UnityStereoScreenSpaceUVAdjust(i.uv, _MainTex_ST);

		o.uv = uv;
		o.blurUV[0].xy = uv + offset1;
		o.blurUV[0].zw = uv - offset1;
		o.blurUV[1].xy = uv + offset2;
		o.blurUV[1].zw = uv - offset2;

		return o;
	}

	out_ninetap vert_ninetap_h(v2f i)
	{
		return vert_ninetap(i, float2(_MainTex_TexelSize.x * _Radius * 1.38461538, 0.0), 
			float2(_MainTex_TexelSize.x * _Radius * 3.23076923, 0.0));
	}

	out_ninetap vert_ninetap_v(v2f i)
	{
		return vert_ninetap(i, float2(0.0, _MainTex_TexelSize.y * _Radius * 1.38461538), 
			float2(0.0, _MainTex_TexelSize.y * _Radius * 3.23076923));
	}

	fixed4 frag_ninetap(out_ninetap i) : SV_TARGET
	{
#if GAMMA_CORRECTION
		fixed3 sum = GammaToLinearSpace(tex2D(_MainTex, i.uv).xyz) * 0.22702702;
		sum += GammaToLinearSpace(tex2D(_MainTex, i.blurUV[0].xy).xyz) * 0.31621621;
		sum += GammaToLinearSpace(tex2D(_MainTex, i.blurUV[0].zw).xyz) * 0.31621621;
		sum += GammaToLinearSpace(tex2D(_MainTex, i.blurUV[1].xy).xyz) * 0.07027027;
		sum += GammaToLinearSpace(tex2D(_MainTex, i.blurUV[1].zw).xyz) * 0.07027027;
		return fixed4(LinearToGammaSpace(sum), 1.0);
#else
		fixed3 sum = tex2D(_MainTex, i.uv).xyz * 0.22702702;
		sum += tex2D(_MainTex, i.blurUV[0].xy).xyz * 0.31621621;
		sum += tex2D(_MainTex, i.blurUV[0].zw).xyz * 0.31621621;
		sum += tex2D(_MainTex, i.blurUV[1].xy).xyz * 0.07027027;
		sum += tex2D(_MainTex, i.blurUV[1].zw).xyz * 0.07027027;
		return fixed4(sum, 1.0);
#endif
	}

	// Large kernel for Gaussian blur. Offset defines direction (horizontal/vertical).
	out_thirteentap vert_thirteentap (v2f i, float2 offset1, float2 offset2, float2 offset3)
	{
		out_thirteentap o;

		o.pos = UnityObjectToClipPos(i.pos);

		float2 uv = UnityStereoScreenSpaceUVAdjust(i.uv, _MainTex_ST);

		o.uv = uv;
		o.blurUV[0].xy = uv + offset1;
		o.blurUV[0].zw = uv - offset1;
		o.blurUV[1].xy = uv + offset2;
		o.blurUV[1].zw = uv - offset2;
		o.blurUV[2].xy = uv + offset3;
		o.blurUV[2].zw = uv - offset3;

		return o;
	}

	out_thirteentap vert_thirteentap_h(v2f i)
	{
		return vert_thirteentap(i, float2(_MainTex_TexelSize.x * _Radius * 1.41176470, 0.0), 
			float2(_MainTex_TexelSize.x * _Radius * 3.29411764, 0.0),
			float2(_MainTex_TexelSize.x * _Radius * 5.17647058, 0.0));
	}

	out_thirteentap vert_thirteentap_v(v2f i)
	{
		return vert_thirteentap(i, float2(0.0, _MainTex_TexelSize.y * _Radius * 1.41176470), 
			float2(0.0, _MainTex_TexelSize.y * _Radius * 3.29411764),
			float2(0.0, _MainTex_TexelSize.y * _Radius * 5.17647058));
	}

	fixed4 frag_thirteentap (out_thirteentap i) : SV_Target
	{
#if GAMMA_CORRECTION
		fixed3 sum = GammaToLinearSpace(tex2D(_MainTex, i.uv).xyz) * 0.19648255;
		sum += GammaToLinearSpace(tex2D(_MainTex, i.blurUV[0].xy).xyz) * 0.29690696;
		sum += GammaToLinearSpace(tex2D(_MainTex, i.blurUV[0].zw).xyz) * 0.29690696;
		sum += GammaToLinearSpace(tex2D(_MainTex, i.blurUV[1].xy).xyz) * 0.09447039;
		sum += GammaToLinearSpace(tex2D(_MainTex, i.blurUV[1].zw).xyz) * 0.09447039;
		sum += GammaToLinearSpace(tex2D(_MainTex, i.blurUV[2].xy).xyz) * 0.01038136;
		sum += GammaToLinearSpace(tex2D(_MainTex, i.blurUV[2].zw).xyz) * 0.01038136;
		return fixed4(LinearToGammaSpace(sum), 1.0);
#else
		fixed3 sum = tex2D(_MainTex, i.uv).xyz * 0.19648255;
		sum += tex2D(_MainTex, i.blurUV[0].xy).xyz * 0.29690696;
		sum += tex2D(_MainTex, i.blurUV[0].zw).xyz * 0.29690696;
		sum += tex2D(_MainTex, i.blurUV[1].xy).xyz * 0.09447039;
		sum += tex2D(_MainTex, i.blurUV[1].zw).xyz * 0.09447039;
		sum += tex2D(_MainTex, i.blurUV[2].xy).xyz * 0.01038136;
		sum += tex2D(_MainTex, i.blurUV[2].zw).xyz * 0.01038136;
		return fixed4(sum, 1.0);
#endif
	}

	ENDCG
	
	SubShader
	{
		Ztest Always Cull Off ZWrite Off

		// Dummy pass.
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			ENDCG
		}

		// 5-tap Passes.
		Pass
		{
			CGPROGRAM
			#pragma multi_compile _ GAMMA_CORRECTION
			#pragma vertex vert_fivetap_h
			#pragma fragment frag_fivetap
			ENDCG
		}

		Pass
		{
			CGPROGRAM
			#pragma multi_compile _ GAMMA_CORRECTION
			#pragma vertex vert_fivetap_v
			#pragma fragment frag_fivetap
			ENDCG
		}

		// 9-tap Passes.
		Pass
		{
			CGPROGRAM
			#pragma multi_compile _ GAMMA_CORRECTION
			#pragma vertex vert_ninetap_h
			#pragma fragment frag_ninetap
			ENDCG
		}

		Pass
		{
			CGPROGRAM
			#pragma multi_compile _ GAMMA_CORRECTION
			#pragma vertex vert_ninetap_v
			#pragma fragment frag_ninetap
			ENDCG
		}

		// 13-tap Passes.
		Pass
		{
			CGPROGRAM
			#pragma multi_compile _ GAMMA_CORRECTION
			#pragma vertex vert_thirteentap_h
			#pragma fragment frag_thirteentap
			ENDCG
		}

		Pass
		{
			CGPROGRAM
			#pragma multi_compile _ GAMMA_CORRECTION
			#pragma vertex vert_thirteentap_v
			#pragma fragment frag_thirteentap
			ENDCG
		}
	}
}
