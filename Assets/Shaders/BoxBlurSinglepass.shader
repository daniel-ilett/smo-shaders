Shader "SMO/BoxBlurSinglepass"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_KernelSize("Kernel Size (N)", Int) = 3
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
				fixed4 tex = tex2D(_MainTex, i.uv);
				return tex;
			}
			ENDCG
        }
    }
}
