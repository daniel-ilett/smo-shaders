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
        filters.Add(new BaseFilter("None", noneShader));
        filters.Add(new BaseFilter("Greyscale", greyscaleShader));
        filters.Add(new BaseFilter("Sepia Tone", sepiaShader));
        filters.Add(new BlurFilter("Blur (Full)", gaussianShader));
        filters.Add(new BlurFilter("Blur (Edge)", edgeBlurShader));
        filters.Add(new BaseFilter("Silhouette", silhouetteShader));
        filters.Add(new BaseFilter("Outlines", outlineShader));
        filters.Add(new NeonFilter("Neon", bloomShader, 
            new BaseFilter("", neonShader)));
        filters.Add(new BloomFilter("Bloom", bloomShader));
        filters.Add(new CRTFilter("NES", crtShader, 
            new PixelFilter("", nesShader)));
        filters.Add(new CRTFilter("SNES", crtShader, 
            new PixelFilter("", snesShader)));
        filters.Add(new PixelFilter("Game Boy", gbShader));
        filters.Add(new BaseFilter("Painting", paintingShader));
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
        if(lastIndex != filterIndex)
        {
            snapshotCanvas.SetFilterName(filters[filterIndex].GetName());
        }
    }

    // Delegate OnRenderImage() to a SnapshotFilter object.
    private void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        filters[filterIndex].OnRenderImage(src, dst);
    }
}
