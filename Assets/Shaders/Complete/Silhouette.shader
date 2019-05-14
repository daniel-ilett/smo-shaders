/*	This shader colourises the depth buffer values to achieve an effect where
	pixels further back have a different colour - based on _FarColour - than
	those immediately in front of the camera - based on _NearColour.
*/
Shader "SMO/Complete/Silhouette"
{
	/*	Define the _NearColour and _FarColour in the Properties so they could
		be modified easily (in scripting or in the Inspector in Unity if this
		shader is used in a material).
	*/
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
			// Include the depth texture so we can use depth buffer values.
			sampler2D _CameraDepthTexture;
			fixed4 _NearColour;
			fixed4 _FarColour;

			/*	Calculate the depth value, modify it slightly so it is in a more
				acceptable range, then use lerp() to pick the correct colour on
				a scale between _NearColour and _FarColour.
			*/
            fixed4 frag (v2f_img i) : SV_Target
            {
                float depth = UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.uv));
				depth = pow(Linear01Depth(depth), 0.75);

				return lerp(_NearColour, _FarColour, depth);
            }
            ENDCG
        }
    }
}
