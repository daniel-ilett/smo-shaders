using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[RequireComponent(typeof(Canvas))]
public class SnapshotCanvas : MonoBehaviour
{
    [SerializeField]
    private Text filterEffectText;

    public void SetFilterName(string name)
    {
        filterEffectText.text = name;
    }
}
