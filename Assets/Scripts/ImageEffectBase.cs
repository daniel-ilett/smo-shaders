using UnityEngine;

[RequireComponent(typeof(Camera))]
public class ImageEffectBase : MonoBehaviour
{
	[SerializeField]
	private Shader shader;
	private Material material;

	private void Awake()
	{
		// Create a new material with the supplied shader.
		material = new Material(shader);
	}

	// OnRenderImage() is called when the camera has finished rendering.
	private void OnRenderImage(RenderTexture src, RenderTexture dst)
	{
		Graphics.Blit(src, dst, material);
	}
}
