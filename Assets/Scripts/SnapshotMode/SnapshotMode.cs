using System.Collections;
using System.Collections.Generic;

using UnityEngine;

[RequireComponent(typeof(Camera))]
public class SnapshotMode : MonoBehaviour
{
    [SerializeField]
    private bool useCanvas = true;

    [SerializeField]
    private SnapshotCanvas snapshotCanvasPrefab;

    private SnapshotCanvas snapshotCanvas;

    private Shader noneShader;
    private Shader greyscaleShader;
    private Shader sepiaShader;
    private Shader gaussianShader;
    private Shader edgeBlurShader;
    private Shader silhouetteShader;
    private Shader outlineShader;
    private Shader neonShader;
    private Shader bloomShader;
    private Shader crtShader;
    private Shader nesShader;
    private Shader snesShader;
    private Shader gbShader;
    private Shader paintingShader;

    private List<SnapshotFilter> filters = new List<SnapshotFilter>();

    private int filterIndex = 0;

    private void Awake()
    {
        // Add a canvas to show the current filter name and the controls.
        if (useCanvas)
        {
            snapshotCanvas = Instantiate(snapshotCanvasPrefab);
        }

        // Find all shader files.
        noneShader = Shader.Find("SMO/Complete/Base");
        greyscaleShader = Shader.Find("SMO/Complete/Greyscale");
        sepiaShader = Shader.Find("SMO/Complete/Sepia");
        gaussianShader = Shader.Find("SMO/Complete/GaussianBlurMultipass");
        edgeBlurShader = Shader.Find("SMO/Complete/EdgeBlur");
        silhouetteShader = Shader.Find("SMO/Complete/Silhouette");
        outlineShader = Shader.Find("SMO/Complete/EdgeDetect");
        neonShader = Shader.Find("SMO/Complete/Neon");
        bloomShader = Shader.Find("SMO/Complete/Bloom");
        crtShader = Shader.Find("SMO/Complete/CRTScreen");
        nesShader = Shader.Find("SMO/Complete/PixelNES");
        snesShader = Shader.Find("SMO/Complete/PixelSNES");
        gbShader = Shader.Find("SMO/Complete/PixelGB");
        paintingShader = Shader.Find("SMO/Complete/Painting");

        // Create all filters.
        filters.Add(new BaseFilter("None", Color.white, noneShader));
        filters.Add(new BaseFilter("Greyscale", Color.white, greyscaleShader));
        filters.Add(new BaseFilter("Sepia Tone", new Color(1.00f, 1.00f, 0.79f), 
            sepiaShader));
        filters.Add(new BlurFilter("Blur (Full)", Color.white, gaussianShader));
        filters.Add(new BlurFilter("Blur (Edge)", Color.white, edgeBlurShader));
        filters.Add(new BaseFilter("Silhouette", new Color(0.89f, 0.71f, 0.56f), 
            silhouetteShader));
        filters.Add(new BaseFilter("Outlines", Color.white, outlineShader));
        filters.Add(new NeonFilter("Neon", Color.cyan, bloomShader, 
            new BaseFilter("", Color.white, neonShader)));
        filters.Add(new BloomFilter("Bloom", Color.white, bloomShader));
        filters.Add(new CRTFilter("NES", new Color(0.66f, 1.00f, 1.00f), 
            crtShader, new PixelFilter("", Color.white, nesShader)));
        filters.Add(new CRTFilter("SNES", new Color(0.80f, 1.00f, 1.00f), 
            crtShader, new PixelFilter("", Color.white, snesShader)));
        filters.Add(new PixelFilter("Game Boy", new Color(0.61f, 0.73f, 0.06f), 
            gbShader));
        filters.Add(new BaseFilter("Painting", Color.white, paintingShader));
    }

    private void Update()
    {
        int lastIndex = filterIndex;

        // Logic to swap between filters.
        if(Input.GetMouseButtonDown(0))
        {
            if(--filterIndex < 0)
            {
                filterIndex = filters.Count - 1;
            }
        }
        else if (Input.GetMouseButtonDown(1))
        {
            if(++filterIndex >= filters.Count)
            {
                filterIndex = 0;
            }
        }

        // Change the filter name when appropriate.
        if(useCanvas && lastIndex != filterIndex)
        {
            snapshotCanvas.SetFilterProperties(filters[filterIndex]);
        }
    }

    // Delegate OnRenderImage() to a SnapshotFilter object.
    private void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        filters[filterIndex].OnRenderImage(src, dst);
    }
}
