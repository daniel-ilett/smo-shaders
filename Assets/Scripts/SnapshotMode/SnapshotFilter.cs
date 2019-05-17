using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class SnapshotFilter
{
    private Material mainMaterial;

    public SnapshotFilter(Shader shader)
    {
        mainMaterial = new Material(shader);
    }

    public abstract void OnRenderImage(RenderTexture src, RenderTexture dst);
}

public class BaseFilter : SnapshotFilter
{
    public BaseFilter(Shader shader) : base(shader)
    {

    }

    public override void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        throw new System.NotImplementedException();
    }
}

public class BlurFilter : SnapshotFilter
{
    public BlurFilter(Shader shader) : base(shader)
    {

    }

    public override void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        throw new System.NotImplementedException();
    }
}

public class BloomFilter : SnapshotFilter
{
    public BloomFilter(Shader shader) : base(shader)
    {

    }

    public override void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        throw new System.NotImplementedException();
    }
}

public class NeonFilter : BloomFilter
{
    public NeonFilter(Shader shader) : base(shader)
    {

    }

    public override void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        throw new System.NotImplementedException();
    }
}

public class PixelFilter : SnapshotFilter
{
    public PixelFilter(Shader shader) : base(shader)
    {

    }

    public override void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        throw new System.NotImplementedException();
    }
}

public class CRTFilter : PixelFilter
{
    public CRTFilter(Shader shader) : base(shader)
    {

    }

    public override void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        throw new System.NotImplementedException();
    }
}
