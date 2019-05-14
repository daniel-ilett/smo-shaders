/*  Hover an object relative to its parent over time.
 */
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Hover : MonoBehaviour
{
    [SerializeField]
    private Vector3 hoverVector;

    [SerializeField]
    private Transform hoverTransform;

    private Vector3 startPos;

    private void Awake()
    {
        startPos = hoverTransform.localPosition;
    }

    private void Update()
    {
        hoverTransform.localPosition = startPos + hoverVector * Mathf.Sin(Time.time);
    }
}
