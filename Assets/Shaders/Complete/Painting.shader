/*	This shader separates the kernel into four (overlapping) regions. The
	variance and of each region is calculated, then the region with the lowest
	variance is picked and its mean pixel colour is used as the output pixel
	colour. The kernel is split into four regions like this, for a kernel size
	of 5:

	*------*------*------*------*------*
	|  C   |  C   |  CD  |   D  |   D  |	Region A: Bottom-left
	|      |      |      |      |      |
	*------*------*------*------*------*
	|  C   |  C   |  CD  |   D  |   D  |	Region B: Bottom-right
	|      |      |      |      |      |
	*------*------*------*------*------*
	|  C   |  C   |  CD  |   D  |   D  |	Region C: Top-left
	|  A   |  A   |  AB  |   B  |   B  |
	*------*------*------*------*------*
	|      |      |      |      |      |	Region D: Top-right
	|  A   |  A   |  AB  |   B  |   B  |
	*------*------*------*------*------*					*------*
	|      |      |      |      |      |	Centre pixel:	|  CD  |
	|  A   |  A   |  AB  |   B  |   B  |					|  AB  |
	*------*------*------*------*------*					*------*

	The idea is that the most "stable" region - one representative of the
	pixel's colour - is picked.
*/
Shader "SMO/Complete/Painting"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_KernelSize("Kernel Size (N)", Int) = 17
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
			float2 _MainTex_TexelSize;

			int _KernelSize;

			/* To avoid recalculating the mean once we have found the region
				with the lowest variance (and because the mean is going to be
				calculated anyway), we'll package both inside a struct.
			*/
			struct region
			{
				float3 mean;
				float variance;
			};

			/*	Given a region bound and a centre-pixel UV, calculate the mean
				and variance of the region.
			*/
			region calcRegion(int2 lower, int2 upper, int samples, float2 uv)
			{
				region r;
				float3 sum = 0.0;
				float3 squareSum = 0.0;

				for (int x = lower.x; x <= upper.x; ++x)
				{
					for (int y = lower.y; y <= upper.y; ++y)
					{
						float2 offset = float2(_MainTex_TexelSize.x * x, _MainTex_TexelSize.y * y);
						float3 tex = tex2D(_MainTex, uv + offset);
						sum += tex;
						squareSum += tex * tex;
					}
				}

				r.mean = sum / samples;
				float3 variance = abs((squareSum / samples) - (r.mean * r.mean));
				r.variance = length(variance);

				return r;
			}

            fixed4 frag (v2f_img i) : SV_Target
            {
				int upper = (_KernelSize - 1) / 2;
				int lower = -upper;

				int samples = (upper + 1) * (upper + 1);

				// Calculate the four regional parameters as discussed.
				region regionA = calcRegion(int2(lower, lower), int2(0, 0), samples, i.uv);
				region regionB = calcRegion(int2(0, lower), int2(upper, 0), samples, i.uv);
				region regionC = calcRegion(int2(lower, 0), int2(0, upper), samples, i.uv);
				region regionD = calcRegion(int2(0, 0), int2(upper, upper), samples, i.uv);

				fixed3 col = regionA.mean;
				fixed minVar = regionA.variance;

				/*	Cascade through each region and compare variances - the end
					result will be the that the correct mean is picked for col.
				*/
				float testVal;

				testVal = step(regionB.variance, minVar);
				col = lerp(col, regionB.mean, testVal);
				minVar = lerp(minVar, regionB.variance, testVal);

				testVal = step(regionC.variance, minVar);
				col = lerp(col, regionC.mean, testVal);
				minVar = lerp(minVar, regionC.variance, testVal);

				testVal = step(regionD.variance, minVar);
				col = lerp(col, regionD.mean, testVal);

				return fixed4(col, 1.0);
            }
            ENDCG
        }
    }
}
