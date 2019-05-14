Shader "SMO/PixelGB"
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

            fixed4 frag (v2f_img i) : SV_Target
            {
				fixed4 tex = tex2D(_MainTex, i.uv);

				float lum = dot(tex, float3(0.3, 0.59, 0.11));

				float3 col = lum;

				return float4(col, 1.0);
            }
            ENDCG
        }
    }
}
