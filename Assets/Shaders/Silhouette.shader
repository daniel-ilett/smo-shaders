Shader "SMO/Silhouette"
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
			sampler2D _CameraDepthTexture;

            fixed4 frag (v2f_img i) : SV_Target
            {
				float depth = 0.0;

				return depth;
            }
            ENDCG
        }
    }
}
