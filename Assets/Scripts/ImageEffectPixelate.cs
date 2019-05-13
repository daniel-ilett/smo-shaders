using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ImageEffectPixelate : ImageEffectBase
{
	[SerializeField]
	private int pixelSize = 2;

	protected override void OnRenderImage(RenderTexture src, RenderTexture dst)
	{
		int width  = src.width / pixelSize;
		int height = src.height / pixelSize;

		RenderTexture temp = 
			RenderTexture.GetTemporary(width, height, 0, src.format);

		// Make sure the upsampling does not interpolate.
		temp.filterMode = FilterMode.Point;

		// Obtain a smaller version of the source input.
		Graphics.Blit(src, temp);

		Graphics.Blit(temp, dst, material);
	}
}
