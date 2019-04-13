using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))]
public class PPSepia : PPBase
{
	private Material mat;

	[Range(0.0f, 1.0f)]
	public float blendAmount;

	private void Awake()
	{
		mat = new Material(shader);
	}

	private void OnRenderImage(RenderTexture src, RenderTexture dst)
	{
		// Do nothing special if blend amount is zero.
		if (Mathf.Approximately(blendAmount, 0.0f))
		{
			Graphics.Blit(src, dst);
			return;
		}

		mat.SetFloat("_BlendAmount", blendAmount);
		Graphics.Blit(src, dst, mat);
	}
}
