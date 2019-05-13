/*	This shader uses a Sobel edge detector to determine whether a pixel lies on
	an edge of the image using image gradients in the x- and y-directions.
*/
Shader "SMO/Complete/EdgeDetect"
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

			/*	This function uses two Sobel filters to calculate image
				gradients in the x- and y-directions:

						*----*----*----*				*----*----*----*
						| -1 |  0 |  1 |				|  1 |  2 |  1 |
						*----*----*----*				*----*----*----*
				S_x =	| -2 |  0 |  2 |		S_y =	|  0 |  0 |  0 |
						*----*----*----*				*----*----*----*
						| -1 |  0 |  1 |				| -1 | -2 | -1 |
						*----*----*----*				*----*----*----*

				Then, simple trigonometry is used to calculate the overall
				magnitude of the gradient.
			*/
			float3 sobel(float2 uv)
			{
				float x = 0;
				float y = 0;

				float2 texelSize = _MainTex_TexelSize;

				// Values are hardcoded for simplicity. Kernel values with
				// zeroes are missed out for efficiency.
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

			fixed4 frag(v2f_img i) : SV_Target
			{
				return fixed4(sobel(i.uv), 1.0);
			}
			ENDCG
        }
    }
}
