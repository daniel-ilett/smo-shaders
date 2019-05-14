/*	This shader quantises/thersholds each of the red, green and blue colour
	channels to four possible values and outputs the resulting values.

	This shader works best with the ImageEffectPixelate.cs script.
*/
Shader "SMO/Complete/PixelNES"
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
				int r = (tex.r - EPSILON) * 4;
				int g = (tex.g - EPSILON) * 4;
				int b = (tex.b - EPSILON) * 4;

				/*	Divide by 3, not 4, because we're dividing by the maximum
					value of each channel integer (which is 3).
				*/
				return float4(r / 3.0, g / 3.0, b / 3.0, 1.0);
            }
            ENDCG
        }
    }
}
