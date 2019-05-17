using System.Collections;
using System.Collections.Generic;

using UnityEngine;

[RequireComponent(typeof(Camera))]
public class SnapshotMode : MonoBehaviour
{
    [SerializeField]
    private bool useCanvas = true;

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

        // Add a canvas to show the current filter name and the controls.
        if(useCanvas)
        {

        }

        filters.Add(new BaseFilter(noneShader));

        filters.Add(new BaseFilter(greyscaleShader));

        filters.Add(new BaseFilter(sepiaShader));

        filters.Add(new BlurFilter(gaussianShader));

        filters.Add(new BlurFilter(edgeBlurShader));

        filters.Add(new BaseFilter(silhouetteShader));

        filters.Add(new BaseFilter(outlineShader));

        filters.Add(new NeonFilter(bloomShader, new BaseFilter(neonShader)));

        filters.Add(new BloomFilter(bloomShader));

        filters.Add(new CRTFilter(crtShader, new PixelFilter(nesShader), 
            new BloomFilter(bloomShader)));

        filters.Add(new CRTFilter(crtShader, new PixelFilter(snesShader),
            new BloomFilter(bloomShader)));

        filters.Add(new PixelFilter(gbShader));

        filters.Add(new BaseFilter(paintingShader));
    }

    private void Update()
    {
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
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        filters[filterIndex].OnRenderImage(src, dst);
    }
}
