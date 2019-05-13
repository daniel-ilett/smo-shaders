/*	This shader is almost exactly the same as the EdgeDetect.shader file, except
	the image gradient values are colourised. The original colours are modified
	to have maximum brightness and saturation (but they keep the same hue),
	resulting in only bright colours.
*/
Shader "SMO/Complete/Neon"
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

				x += tex2D(_MainTex, uv + float2(-texelSize.x, -texelSize.y)) * -1.0;
				x += tex2D(_MainTex, uv + float2(-texelSize.x,            0)) * -2.0;
				x += tex2D(_MainTex, uv + float2(-texelSize.x,  texelSize.y)) * -1.0;

				x += tex2D(_MainTex, uv + float2( texelSize.x, -texelSize.y)) *  1.0;
				x += tex2D(_MainTex, uv + float2( texelSize.x,            0)) *  2.0;
				x += tex2D(_MainTex, uv + float2( texelSize.x,  texelSize.y)) *  1.0;

				y += tex2D(_MainTex, uv + float2(-texelSize.x, -texelSize.y)) * -1.0;
				y += tex2D(_MainTex, uv + float2(           0, -texelSize.y)) * -2.0;
				y += tex2D(_MainTex, uv + float2( texelSize.x, -texelSize.y)) * -1.0;

				y += tex2D(_MainTex, uv + float2(-texelSize.x,  texelSize.y)) *  1.0;
				y += tex2D(_MainTex, uv + float2(           0,  texelSize.y)) *  2.0;
				y += tex2D(_MainTex, uv + float2( texelSize.x,  texelSize.y)) *  1.0;

				return sqrt(x * x + y * y);
			}

			// Credit: http://lolengine.net/blog/2013/07/27/rgb-to-hsv-in-glsl
			float3 rgb2hsv(float3 c)
			{
				float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
				float4 p = c.g < c.b ? float4(c.bg, K.wz) : float4(c.gb, K.xy);
				float4 q = c.r < p.x ? float4(p.xyw, c.r) : float4(c.r, p.yzx);

				float d = q.x - min(q.w, q.y);
				float e = 1.0e-10;
				return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
			}

			// Credit: http://lolengine.net/blog/2013/07/27/rgb-to-hsv-in-glsl
			float3 hsv2rgb(float3 c)
			{
				float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
				float3 p = abs(frac(c.xxx + K.xyz) * 6.0 - K.www);
				return c.z * lerp(K.xxx, saturate(p - K.xxx), c.y);
			}

			/*	Calculate the sobel value and multiply by a bright, saturated
				version of the original pixel colour.
			*/
			fixed4 frag(v2f_img i) : SV_Target
			{
				float3 s = sobel(i.uv);
				float3 tex = tex2D(_MainTex, i.uv);

				float3 hsvTex = rgb2hsv(tex);
				hsvTex.y = 1.0;		// Modify saturation.
				hsvTex.z = 1.0;		// Modify lightness/value.
				float3 col = hsv2rgb(hsvTex);

				return float4(col * s, 1.0);
			}
			ENDCG
        }
    }
}
