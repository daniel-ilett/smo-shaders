/*	This shader implements a CRT screen effect by mapping pixels in a special
	way such that they output mostly a red, green or blur colour based on its
	column, or completely black if it's a scanline:

	*---*---*---*---*---*---*	R = Red pixel
	| R | G | B | R | G | B |	G = Green pixel
	*---*---*---*---*---*---*	B = Blue pixel
	| R | G | B | R | G | B |	S = Scanline (black) pixel
	*---*---*---*---*---*---*
	| S | S | S | S | S | S |
	*---*---*---*---*---*---*

	This occurs in a 3x3 pixel pattern, so it it best complemented by a shader
	using the ImageEffectPixelate.cs script with the pixelation set to 3. There
	is some 'bleeding' of colour horizontally to emulate the way a CRT's
	electron gun sweeps across each scanline horizontally.

	The shader requires the ImageEffectCRT.cs script to operate correctly and
	set the values of _Brightness and _Contrast.
*/
Shader "SMO/Complete/CRTScreen"
{
	/*	The _Brightness and _Contrast values can be tweaked to match those of a
		CRT screen. Brightness is important to counteract the darkening effect
		of faking a dark scanline in the image.
	*/
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Brightness("Brightness", Float) = 0
		_Contrast("Contrast", Float) = 0
	}
	SubShader
	{
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			/*	screenPos is used to detect which 'column' and 'row' a pixel
				is in to assign the correct 'colour', as described in the
				diagram above.
			*/
			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 screenPos: TEXCOORD1;
			};

			v2f vert (appdata_img v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.screenPos = ComputeScreenPos(o.vertex);
				o.uv = v.texcoord;
				return o;
			}
			
			sampler2D _MainTex;
			float _Brightness;
			float _Contrast;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
			
				fixed2 sp = i.screenPos.xy * _ScreenParams.xy;

				/*	The values that are divided by 4 represent the 'colour
					bleed' as discussed.
				*/
				float3 r = float3(col.r,     col.g / 4, col.b / 4);
				float3 g = float3(col.r / 4, col.g,     col.b / 4);
				float3 b = float3(col.r / 4, col.g / 4, col.b);
				float3x3 colormap = float3x3(r, g, b);

				float3 wh = 1.0;
				float3 bl = 0.0;

				float3x3 scanlineMap = float3x3(wh, wh, bl);

				/*	The matrices are being accessed like arrays here:

						colormap[0] = r = (col.r, col.g / 4, col.b / 4)
						scanlineMap[2] = bl = (0.0, 0.0, 0.0)

					The pixel rows and columns are used (with modulo (i.e. %) 
					arithmetic) to determine the 'array index'.
				*/
				fixed3 returnVal = colormap[(int)sp.x % 3] * scanlineMap[(int)sp.y % 3];

				/*	Apply the brightness and contrast modifiers.
				*/
				returnVal += (_Brightness / 255);
				returnVal = saturate(returnVal);
				returnVal = returnVal - _Contrast * (returnVal - 1.0) * returnVal * (returnVal - 0.5);

				return fixed4(returnVal, 1.0);
			}
			ENDCG
		}
	}
}
