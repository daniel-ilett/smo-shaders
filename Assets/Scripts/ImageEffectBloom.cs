using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ImageEffectBloom : ImageEffectBase
{
	private const int thresholdPass = 0;
	private const int blurPass = 1;
	private const int bloomPass = 2;

	protected override void OnRenderImage(RenderTexture src, RenderTexture dst)
	{
		RenderTexture thresholdTex = 
			RenderTexture.GetTemporary(src.width, src.height, 0, src.format);

		Graphics.Blit(src, thresholdTex, material, thresholdPass);

		RenderTexture blurTex =
			RenderTexture.GetTemporary(src.width, src.height, 0, src.format);

		material.SetInt("_KernelSize", 21);
		material.SetFloat("_Spread", 5.0f);

		Graphics.Blit(thresholdTex, blurTex, material, blurPass);

		RenderTexture.ReleaseTemporary(thresholdTex);

		material.SetTexture("_SrcTex", src);

		Graphics.Blit(blurTex, dst, material, bloomPass);

		RenderTexture.ReleaseTemporary(blurTex);
	}
}
