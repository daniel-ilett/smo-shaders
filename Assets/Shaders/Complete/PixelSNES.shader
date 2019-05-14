/*	This shader takes an almost identical route to the PixelNES.shader file,
	except 6 possible values are used for each channel instead of 4.

	This shader works best with the ImageEffectPixelate.cs script.
*/
Shader "SMO/Complete/PixelSNES"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4    _MainTex_ST;

			/*	The epsilon value is used to prevent an input value of 1.0
				mapping above our desired maximum range of integer values.
			*/
			static const float EPSILON = 1e-10;

            fixed4 frag (v2f_img i) : SV_Target
            {
				fixed4 tex = tex2D(_MainTex, i.uv);

				/*	To achieve the thresholding of colour values, integer
					truncation is used.
				*/
				int r = (tex.r - EPSILON) * 6;
				int g = (tex.g - EPSILON) * 6;
				int b = (tex.b - EPSILON) * 6;

				/*	Divide by 5, not 6, because we're dividing by the maximum
					value of each channel integer (which is 6).
					value of each channel integer (which is 6).
				*/
				return float4(r / 5.0, g / 5.0, b / 5.0, 1.0);
            }
            ENDCG
        }
    }
}
