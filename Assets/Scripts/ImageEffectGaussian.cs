using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ImageEffectGaussian : ImageEffectBase
{
	protected override void OnRenderImage(RenderTexture src, RenderTexture dst)
	{
		// Create a temporary RenderTexture to hold the first pass.
		RenderTexture tmp = 
			RenderTexture.GetTemporary(src.width, src.height, 0, src.format);

		// Perform both passes in order.
		Graphics.Blit(src, tmp, material, 0);
		Graphics.Blit(tmp, dst, material, 1);

		RenderTexture.ReleaseTemporary(tmp);
	}
}
