/*	This shader picks between four possible colours based on the luminance of
	the pixel. It is very similar to the Greyscale shader, with the added step
	of picking one of four colours.

	This shader works best with the ImageEffectPixelate.cs script.
*/
Shader "SMO/Complete/PixelGB"
{
	/*	The Game Boy could use different palettes, so we allow passing in
		four colours to represent the four possible shades.
	*/
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_GBDarkest("GB (Darkest)", Color) = (0.06, 0.22, 0.06, 1.0)
		_GBDark("GB (Dark)", Color) = (0.19, 0.38, 0.19, 1.0)
		_GBLight("GB (Light)", Color) = (0.54, 0.67, 0.06, 1.0)
		_GBLightest("GB (Lightest)", Color) = (0.61, 0.73, 0.06, 1.0)
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

			float4 _GBDarkest;
			float4 _GBDark;
			float4 _GBLight;
			float4 _GBLightest;

			/*	Once the luminance is calculated, the 'lerp-saturate cascade'
				trick is used to pick the correct colour instead of slow
				branching (if-statements).
			*/
            fixed4 frag (v2f_img i) : SV_Target
            {
				fixed4 tex = tex2D(_MainTex, i.uv);

				float lum = dot(tex, float3(0.3, 0.59, 0.11));

				int gb = lum * 3;

				float3 col = lerp(_GBDarkest, _GBDark, saturate(gb));
				col = lerp(col, _GBLight, saturate(gb - 1.0));
				col = lerp(col, _GBLightest, saturate(gb - 2.0));

				return float4(col, 1.0);
            }
            ENDCG
        }
    }
}
