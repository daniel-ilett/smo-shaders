using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class SnapshotFilter
{
    protected Material mainMaterial;

    protected string name;
    protected Color color;

    public SnapshotFilter(string name, Color color, Shader shader)
    {
        this.name = name;
        this.color = color;
        mainMaterial = new Material(shader);
    }

    public abstract void OnRenderImage(RenderTexture src, RenderTexture dst);

    public string GetName()
    {
        return name;
    }

    public Color GetColor()
    {
        return color;
    }
}

/*  A BaseFilter just takes an input texture and applies a Blit() without any
 *  messing with pass IDs or secondary materials.
 */
public class BaseFilter : SnapshotFilter
{
    public BaseFilter(string name, Color color, Shader shader) 
        : base(name, color, shader)
    {

    }

    public override void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        Graphics.Blit(src, dst, mainMaterial);
    }
}

/*  A BlurFilter needs to save the first pass in an intermediate texture, then
 *  perform the second pass.
 */
public class BlurFilter : SnapshotFilter
{
    public BlurFilter(string name, Color color, Shader shader) 
        : base(name, color, shader)
    {
        mainMaterial.SetInt("_KernelSize", 21);
    }

    public override void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        // Create a temporary RenderTexture to hold the first pass.
        RenderTexture tmp =
            RenderTexture.GetTemporary(src.width, src.height, 0, src.format);

        // Perform both passes in order.
        Graphics.Blit(src, tmp, mainMaterial, 0);   // First pass.
        Graphics.Blit(tmp, dst, mainMaterial, 1);   // Second pass.

        RenderTexture.ReleaseTemporary(tmp);
    }
}

/*  BloomFilter needs to create a blur texture using the image highlights and
 *  composite the results onto the original image.
 */
public class BloomFilter : BlurFilter
{
    // IDs of each pass inside the shader.
    private const int thresholdPass = 0;
    private const int horizontalPass = 2;
    private const int verticalPass = 3;
    private const int bloomPass = 4;

    public BloomFilter(string name, Color color, Shader shader) 
        : base(name, color, shader)
    {
        // Set Gaussian blur properties.
        mainMaterial.SetFloat("_Spread", 5.0f);
    }

    public override void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        RenderTexture thresholdTex =
            RenderTexture.GetTemporary(src.width, src.height, 0, src.format);

        Graphics.Blit(src, thresholdTex, mainMaterial, thresholdPass);

        RenderTexture blurTex =
            RenderTexture.GetTemporary(src.width, src.height, 0, src.format);

        // Perform the blur seen in BlurFilter.
        base.OnRenderImage(thresholdTex, blurTex);

        RenderTexture.ReleaseTemporary(thresholdTex);

        mainMaterial.SetTexture("_SrcTex", src);

        Graphics.Blit(blurTex, dst, mainMaterial, bloomPass);

        RenderTexture.ReleaseTemporary(blurTex);
    }
}
/*  A NeonFilter is based on both BloomFilter and BaseFilter, so a BaseFilter is
 *  passed in for the edge-detect and colourisation step, then a BloomFilter is
 *  inherited for the Bloom step.
 */
public class NeonFilter : BloomFilter
{
    private BaseFilter neonFilter;

    public NeonFilter(string name, Color color, Shader shader, BaseFilter neonFilter) 
        : base(name, color, shader)
    {
        this.neonFilter = neonFilter;
    }

    public override void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        RenderTexture tmp =
            RenderTexture.GetTemporary(src.width, src.height, 0, src.format);

        neonFilter.OnRenderImage(src, tmp);

        base.OnRenderImage(tmp, dst);

        RenderTexture.ReleaseTemporary(tmp);
    }
}

/*  A PixelFilter must downsample the image before applying an effect.
 */
public class PixelFilter : SnapshotFilter
{
    private const int pixelSize = 3;

    public PixelFilter(string name, Color color, Shader shader) 
        : base(name, color, shader)
    {

    }

    public override void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        int width = src.width / pixelSize;
        int height = src.height / pixelSize;

        RenderTexture tmp =
            RenderTexture.GetTemporary(width, height, 0, src.format);

        // Make sure the upsampling does not interpolate.
        tmp.filterMode = FilterMode.Point;

        // Obtain a smaller version of the source input.
        Graphics.Blit(src, tmp);

        Graphics.Blit(tmp, dst, mainMaterial);

        RenderTexture.ReleaseTemporary(tmp);
    }
}

/*  A CRTFilter is based on PixelFilter for its colourisation. It also needs to 
 *  apply its own CRT pixel overlay, so it is based on BaseFilter too. The 
 *  PixelFilter is passed in as an argument and the class inherits BaseFilter.
 */
public class CRTFilter : BaseFilter
{
    private PixelFilter pixelFilter;

    private const float brightness = 27.0f;
    private const float contrast = 2.1f;

    public CRTFilter(string name, Color color, Shader shader, PixelFilter pixelFilter) 
        : base(name, color, shader)
    {
        this.pixelFilter = pixelFilter;

        mainMaterial.SetFloat("_Brightness", brightness);
        mainMaterial.SetFloat("_Contrast", contrast);
    }

    public override void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        RenderTexture tmp = 
            RenderTexture.GetTemporary(src.width, src.height, 0, src.format);

        pixelFilter.OnRenderImage(src, tmp);

        Graphics.Blit(tmp, dst, mainMaterial);

        RenderTexture.ReleaseTemporary(tmp);
    }
}
