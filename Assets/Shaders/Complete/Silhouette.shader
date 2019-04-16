Shader "SMO/Complete/Silhouette"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_NearColour ("Near Clip Colour", Color) = (0.75, 0.35, 0, 1)
		_FarColour  ("Far Clip Colour", Color)  = (1, 1, 1, 1)
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
			fixed4 _NearColour;
			fixed4 _FarColour;

            fixed4 frag (v2f_img i) : SV_Target
            {
                float depth = UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.uv));
				depth = pow(Linear01Depth(depth), 3);

				return lerp(_NearColour, _FarColour, depth);
            }
            ENDCG
        }
    }
}
