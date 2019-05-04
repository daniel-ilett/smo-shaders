Shader "SMO/GaussianBlurMultipass"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_KernelSize("Kernel Size (N)", Int) = 21
		_Spread("St. dev. (sigma)", Float) = 5.0
	}

	CGINCLUDE
	#include "UnityCG.cginc"

	// Define the constants used in Gaussian calculation.
	static const float TWO_PI = 6.28319;
	static const float E = 2.71828;

	sampler2D _MainTex;
	float4 _MainTex_ST;
	float2 _MainTex_TexelSize;
	int	_KernelSize;
	float _Spread;

	// One-dimensional Gaussian curve function.
	float gaussian(int x)
	{
		return 1.0;
	}

	ENDCG

    SubShader
    {
        Tags 
		{ 
			"RenderType" = "Opaque"
		}

        Pass
        {
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag_horizontal

			float4 frag_horizontal(v2f_img i) : SV_Target
			{
				fixed3 col = fixed3(0.0, 0.0, 0.0);

				int upper = ((_KernelSize - 1) / 2);
				int lower = -upper;

				for (int x = lower; x <= upper; ++x)
				{
					col += tex2D(_MainTex, i.uv + fixed2(_MainTex_TexelSize.x * x, 0.0));
				}

				col /= _KernelSize;
				return fixed4(col, 1.0);
			}
			ENDCG
        }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag_vertical

			float4 frag_vertical(v2f_img i) : SV_Target
			{
				fixed3 col = fixed3(0.0, 0.0, 0.0);

				int lower = -((_KernelSize - 1) / 2);
				int upper = -lower;

				for (int y = lower; y <= upper; ++y)
				{
					col += tex2D(_MainTex, i.uv + fixed2(0.0, _MainTex_TexelSize.y * y));
				}

				col /= _KernelSize;
				return fixed4(col, 1.0);
			}
			ENDCG
		}
    }
}
