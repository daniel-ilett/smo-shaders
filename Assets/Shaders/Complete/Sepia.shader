/*	This shader is similar to Greyscale.shader, except the mapping doesn't just
	map one value to R, G and B; all three colour channel inputs influence the 
	output of each of the three colour channels.
*/
Shader "SMO/Complete/Sepia"
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

            fixed4 frag (v2f_img i) : SV_Target
            {
                fixed4 tex = tex2D(_MainTex, i.uv);

				/*	These coefficients represent the sepia-tone transform.

					output r = 0.393 * tex.r + 0.349 * tex.g + 0.272 * tex.b
					output g = 0.769 * tex.r + 0.686 * tex.g + 0.534 * tex.b
					output b = 0.189 * tex.r + 0.168 * tex.g + 0.131 * tex.b

					The coefficients are based on eye sensitivity to each colour
					and the relative amounts of each colour found in old-timey
					sepia-tone photographs.
				*/
				half3x3 sepiaMatrix = half3x3
				(
					0.393, 0.349, 0.272,	// Red.
					0.769, 0.686, 0.534,	// Green.
					0.189, 0.168, 0.131		// Blue.
				);

				half3 sepia = mul(tex.rgb, sepiaMatrix);

				return half4(sepia, tex.a);
            }
            ENDCG
        }
    }
}
