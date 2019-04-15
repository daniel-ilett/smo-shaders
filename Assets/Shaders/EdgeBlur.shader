Shader "SMO/EdgeBlur"
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
	float gaussian(int x, float sigma)
	{
		float sigmaSqu = sigma * sigma;
		return (1 / sqrt(TWO_PI * sigmaSqu)) * pow(E, -(x * x) / (2 * sigmaSqu));
	}

	// Helper function to calculate distance from the centre.
	float getSigma(float2 uv)
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
				float3 col = float3(0.0, 0.0, 0.0);
				float kernelSum = 0.0;

				int lower = -((_KernelSize - 1) / 2);
				int upper = -lower;

				for (int x = lower; x <= upper; ++x)
				{
					float sigma = getSigma(i.uv) * _Spread;
					float gauss = gaussian(x, sigma);
					kernelSum += gauss;
					col += gauss * tex2D(_MainTex, i.uv + fixed2(_MainTex_TexelSize.x * x, 0.0));
				}

				col /= kernelSum;
				return float4(col, 1.0);
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
				float3 col = float3(0.0, 0.0, 0.0);
				float kernelSum = 0.0;

				int lower = -((_KernelSize - 1) / 2);
				int upper = -lower;

				for (int y = lower; y <= upper; ++y)
				{
					float sigma = getSigma(i.uv) * _Spread;
					float gauss = gaussian(y, sigma);
					kernelSum += gauss;
					col += gauss * tex2D(_MainTex, i.uv + fixed2(0.0, _MainTex_TexelSize.y * y));
				}

				col /= kernelSum;
				return float4(col, 1.0);
			}
			ENDCG
		}
    }
}
