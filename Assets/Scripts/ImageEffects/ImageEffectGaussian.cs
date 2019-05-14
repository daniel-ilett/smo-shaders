using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ImageEffectGaussian : ImageEffectBase
{
    [SerializeField]
    private int kernelSize = 21;

    private void Start()
    {
        material.SetInt("_KernelSize", kernelSize);
    }

    protected override void OnRenderImage(RenderTexture src, RenderTexture dst)
	{
		// Create a temporary RenderTexture to hold the first pass.
		RenderTexture tmp = 
			RenderTexture.GetTemporary(src.width, src.height, 0, src.format);

		// Perform both passes in order.
		Graphics.Blit(src, tmp, material, 0);	// First pass.
		Graphics.Blit(tmp, dst, material, 1);	// Second pass.

		RenderTexture.ReleaseTemporary(tmp);
	}
}
