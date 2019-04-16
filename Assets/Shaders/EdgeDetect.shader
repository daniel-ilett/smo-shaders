Shader "SMO/EdgeDetect"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
			float2 _MainTex_TexelSize;

			float3 sobel(float2 uv)
			{
				float x = 0;
				float y = 0;

				float2 texelSize = _MainTex_TexelSize;

				return sqrt(x * x + y * y);
			}

			// Horizontal blurring pass.
			fixed4 frag(v2f_img i) : SV_Target
			{
				return fixed4(sobel(i.uv), 1.0);
			}
			ENDCG
        }
    }
}
