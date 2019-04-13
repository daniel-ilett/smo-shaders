Shader "Hidden/PPDepth"
{
	Properties
	{
		_MainTex("Base (RGB)", 2D) = "white" {}
	}

	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 pos : POSITION;
				half2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				half2 uv : TEXCOORD0;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.pos);
				
				o.uv = v.uv;

				return o;
			}

			uniform sampler2D _MainTex;
			uniform sampler2D _CameraDepthTexture;

			fixed4 frag (v2f i) : COLOR
			{
				float depth = UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.uv));

				depth = pow(Linear01Depth(depth), 3);

				// Use depth to render easy fog.
				//fixed4 tex = tex2D(_MainTex, i.uv);
				//return tex * (1 - depth) + fixed4(depth, depth, depth, depth);

				// Just render the depth.
				return depth;
			}

			ENDCG
		}
	}
}
