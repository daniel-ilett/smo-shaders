Shader "SMO/Complete/BoxBlurSingle"
{
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

			// Horizontal blurring pass.
			fixed4 frag(v2f_img i) : SV_Target
			{
				fixed3 sum = fixed3(0.0, 0.0, 0.0);

				int lower = -((_KernelSize - 1) / 2);
				int upper = -lower;

				for (int x = lower; x <= upper; ++x)
				{
					for (int y = lower; y <= upper; ++y)
					{
						fixed2 offset = fixed2(_MainTex_TexelSize.x * x, _MainTex_TexelSize.y * y);
						sum += tex2D(_MainTex, i.uv + offset);
					}
				}

				sum /= (_KernelSize * _KernelSize);
				return fixed4(sum, 1.0);
			}
			ENDCG
        }
    }
}
