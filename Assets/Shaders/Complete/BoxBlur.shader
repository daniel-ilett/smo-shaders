Shader "SMO/Complete/BoxBlur"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_KernelSize("Kernel Size (N)", Int) = 19
    }

	CGINCLUDE
	#include "UnityCG.cginc"

	sampler2D _MainTex;
	float4 _MainTex_ST;
	float2 _MainTex_TexelSize;
	int	_KernelSize;

	fixed4 frag_horizontal(v2f_img i) : SV_Target
	{
		fixed3 sum = fixed3(0.0, 0.0, 0.0);
		fixed kernelSum = 0.0;

		int lower = -((_KernelSize - 1) / 2);
		int upper = -lower;

		for (int x = lower; x <= upper; ++x)
		{
			sum += tex2D(_MainTex, i.uv + fixed2(_MainTex_TexelSize.x * x, 0.0));
			kernelSum++;
		}

		sum /= kernelSum;
		return fixed4(sum, 1.0);
	}

	fixed4 frag_vertical(v2f_img i) : SV_Target
	{
		fixed3 sum = fixed3(0.0, 0.0, 0.0);
		fixed kernelSum = 0.0;

		int lower = -((_KernelSize - 1) / 2);
		int upper = -lower;

		for (int y = lower; y < upper; ++y)
		{
			sum += tex2D(_MainTex, i.uv + fixed2(0.0, _MainTex_TexelSize.y * y));
			kernelSum++;
		}

		sum /= kernelSum;
		return fixed4(sum, 1.0);
	}
	ENDCG

    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        Pass
        {
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag_horizontal
			ENDCG
        }

		GrabPass 
		{ 
			"_MainTex" 
		}

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag_vertical
			ENDCG
		}
    }
}
