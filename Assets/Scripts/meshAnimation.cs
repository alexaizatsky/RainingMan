using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class meshAnimation : MonoBehaviour
{
    [SerializeField] private int frameStepCount;
    [SerializeField] private bool manualActivating;
    [SerializeField] private bool reverse;
    [SerializeField] private bool loop;
    [SerializeField] private Mesh[] myMeshes;
    [SerializeField] private GameObject[] myObjects;
    private MeshFilter mf;
    private int frame;
    private bool block;
    void Start()
    {
        mf = GetComponent<MeshFilter>();
        if (reverse)
        {
            frame = myObjects.Length - 1;
            mf.mesh = myObjects[frame].transform.GetChild(0).GetComponent<MeshFilter>().sharedMesh;
        }
    }

    public void PlayAnimation()
    {
        manualActivating = false;
    }

    public void ChangeReverse()
    {
        reverse = !reverse;
        if (reverse)
        {
            frame = myObjects.Length - 1;
            
        }
        else
        {
            frame = 0;
            
        }

        block = false;
        mf.mesh = myObjects[frame].transform.GetChild(0).GetComponent<MeshFilter>().sharedMesh;
    }
    private void FixedUpdate()
    {
       // mf.mesh = myMeshes[frame];
       if (!manualActivating)
       {


           if (reverse)
           {
               if (!block)
                   mf.mesh = myObjects[frame].transform.GetChild(0).GetComponent<MeshFilter>().sharedMesh;
               if (frame - frameStepCount >= 0)
               {
                   frame-=frameStepCount;
               }
               else
               {
                   if (!loop)
                       block = true;

                   frame = 0;
               }
           }
           else
           {
               if (!block)
                   mf.mesh = myObjects[frame].transform.GetChild(0).GetComponent<MeshFilter>().sharedMesh;
               if (frame + frameStepCount < myObjects.Length)
               {
                   frame+=frameStepCount;
               }
               else
               {
                   if (!loop)
                       block = true;

                   frame = 0;
               }
           }
       }
    }
}
