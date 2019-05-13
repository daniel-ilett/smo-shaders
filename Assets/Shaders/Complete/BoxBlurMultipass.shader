/*	This shader implements a box blur in two passes. The passes must be
	controlled from an external script (ImageEffectGaussian.cs), else the second
	pass overwrites the first one instead of operating on its output.

	The first pass acts in the horizontal direction, and the second pass acts
	in the vertical direction.
*/
Shader "SMO/Complete/BoxBlurMultipass"
{
	/*	The _KernelSize property controls how many pixels the blurring operation
		runs over.
	*/
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_KernelSize("Kernel Size (N)", Int) = 21
    }

	CGINCLUDE
	#include "UnityCG.cginc"

	sampler2D _MainTex;
	float4 _MainTex_ST;
	float2 _MainTex_TexelSize;
	int	_KernelSize;

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

			// Horizontal blurring pass.
			fixed4 frag_horizontal(v2f_img i) : SV_Target
			{
				fixed3 col = fixed3(0.0, 0.0, 0.0);

				int upper = ((_KernelSize - 1) / 2);
				int lower = -upper;

				// Sum over each pixel colour in the row.
				for (int x = lower; x <= upper; ++x)
				{
					col += tex2D(_MainTex, i.uv + fixed2(_MainTex_TexelSize.x * x, 0.0));
				}

				// Take an unweighted average of the pixel colour sum.
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

			// Vertical burring pass.
			fixed4 frag_vertical(v2f_img i) : SV_Target
			{
				fixed3 col = fixed3(0.0, 0.0, 0.0);

				int upper = ((_KernelSize - 1) / 2);
				int lower = -upper;

				// Sum over each pixel colour in the column.
				for (int y = lower; y <= upper; ++y)
				{
					col += tex2D(_MainTex, i.uv + fixed2(0.0, _MainTex_TexelSize.y * y));
				}

				// Take an unweighted average of the pixel colour sum.
				col /= _KernelSize;
				return fixed4(col, 1.0);
			}
			ENDCG
		}
    }
}
