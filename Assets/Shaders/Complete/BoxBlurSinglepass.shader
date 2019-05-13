/*	This shader implements a box blur in one pass. The passes can be controlled
	using the basic ImageEffectBase.cs script.
*/
Shader "SMO/Complete/BoxBlurSinglepass"
{
	/*	The _KernelSize property controls how many pixels the blurring operation
		runs over.
	*/
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_KernelSize("Kernel Size (N)", Int) = 19
    }

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
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float2 _MainTex_TexelSize;
			int	_KernelSize;

			fixed4 frag(v2f_img i) : SV_Target
			{
				fixed3 col = fixed3(0.0, 0.0, 0.0);

				int upper = ((_KernelSize - 1) / 2);
				int lower = -upper;

				// Sum over all pixel colours in the kernel.
				for (int x = lower; x <= upper; ++x)
				{
					for (int y = lower; y <= upper; ++y)
					{
						fixed2 offset = fixed2(_MainTex_TexelSize.x * x, _MainTex_TexelSize.y * y);
						col += tex2D(_MainTex, i.uv + offset);
					}
				}

				// Divide through to get an unweighted average pixel colour.
				col /= (_KernelSize * _KernelSize);
				return fixed4(col, 1.0);
			}
			ENDCG
        }
    }
}
