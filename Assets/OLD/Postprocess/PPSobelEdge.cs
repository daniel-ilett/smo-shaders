using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))]
public class PPSobelEdge : PPBase
{
	[SerializeField]
	private Vector2 delta = new Vector2(0.01f, 0.01f);

	private Material mat;

	private void Awake()
	{
		mat = new Material(shader);
	}

	private void OnRenderImage(RenderTexture src, RenderTexture dst)
	{
		mat.SetFloat("_DeltaX", delta.x);
		mat.SetFloat("_DeltaY", delta.y);

		Graphics.Blit(src, dst, mat);
	}
}
