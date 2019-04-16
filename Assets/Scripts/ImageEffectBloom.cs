using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ImageEffectBloom : ImageEffectBase
{
	private const int thresholdPass = 0;
	private const int blurPass = 1;
	private const int horizontalPass = 2;
	private const int verticalPass = 3;
	private const int bloomPass = 4;

	[SerializeField]
	private BlurMode blurMode = BlurMode.MultiPass;

	protected override void OnRenderImage(RenderTexture src, RenderTexture dst)
	{
		RenderTexture thresholdTex = 
			RenderTexture.GetTemporary(src.width, src.height, 0, src.format);

		Graphics.Blit(src, thresholdTex, material, thresholdPass);

		RenderTexture blurTex =
			RenderTexture.GetTemporary(src.width, src.height, 0, src.format);

		material.SetInt("_KernelSize", 21);
		material.SetFloat("_Spread", 5.0f);

		if(blurMode == BlurMode.SinglePass)
		{
			Graphics.Blit(thresholdTex, blurTex, material, blurPass);

			RenderTexture.ReleaseTemporary(thresholdTex);
		}
		else
		{
			RenderTexture temp =
				RenderTexture.GetTemporary(src.width, src.height, 0, src.format);

			Graphics.Blit(thresholdTex, temp, material, horizontalPass);
			Graphics.Blit(temp, blurTex, material, verticalPass);

			RenderTexture.ReleaseTemporary(thresholdTex);
			RenderTexture.ReleaseTemporary(temp);
		}

		material.SetTexture("_SrcTex", src);

		Graphics.Blit(blurTex, dst, material, bloomPass);

		RenderTexture.ReleaseTemporary(blurTex);
	}
}

enum BlurMode
{
	SinglePass, MultiPass
}
