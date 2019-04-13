using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))]
public class PPGaussianBlur : PPBase 
{
	[SerializeField]
	BlurKernelSize kernelSize = BlurKernelSize.Small;

	[Range(0.0f, 1.0f)]
	public float blendAmount = 1.0f;

	[Range(0, 4)]
	public int downsample = 1;

	[Range(1, 8)]
	public int iterations = 1;

	public bool gammaCorrection = true;

	[SerializeField]
	private Material blurMat;

	private void Awake()
	{
		blurMat = new Material(blurMat);
	}

	private void Blur(RenderTexture src, RenderTexture dst)
	{
		if(gammaCorrection)
			Shader.EnableKeyword("GAMMA_CORRECTION");
		else
			Shader.DisableKeyword("GAMMA_CORRECTION");

		int kernel = 0;

		switch(kernelSize)
		{
			case BlurKernelSize.Small:
				kernel = 0;
				break;
			case BlurKernelSize.Medium:
				kernel = 2;
				break;
			case BlurKernelSize.Large:
				kernel = 4;
				break;
		}

		RenderTexture temp2 = RenderTexture.GetTemporary(src.width, src.height, 0, src.format);

		for(int i = 0; i < iterations; ++i)
		{
			float radius = (float)i * blendAmount;

			blurMat.SetFloat("_Radius", radius);

			Graphics.Blit(src, temp2, blurMat, 1 + kernel);
			src.DiscardContents();

			if(i == iterations - 1)
				Graphics.Blit(temp2, dst, blurMat, 2 + kernel);
			else
			{
				Graphics.Blit(temp2, src, blurMat, 2 + kernel);
				temp2.DiscardContents();
			}
		}

		RenderTexture.ReleaseTemporary(temp2);
	}

	private void OnRenderImage(RenderTexture src, RenderTexture dst)
	{
		if(blurMat == null)
			return;

		int tw = src.width >> downsample;
		int th = src.height >> downsample;

		RenderTexture temp = RenderTexture.GetTemporary(tw, th, 0, src.format);

		Graphics.Blit(src, temp);

		Blur(temp, dst);

		RenderTexture.ReleaseTemporary(temp);
	}

	enum BlurKernelSize
	{
		Small, Medium, Large
	}
}
