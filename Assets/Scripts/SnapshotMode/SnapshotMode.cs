using System.Collections;
using System.Collections.Generic;

using UnityEngine;

public class SnapshotMode : MonoBehaviour
{
    [SerializeField]
    private bool useCanvas = true;

    private void Awake()
    {
        // Add a canvas to show the current filter name and the controls.
        if(useCanvas)
        {

        }
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        
    }
}
