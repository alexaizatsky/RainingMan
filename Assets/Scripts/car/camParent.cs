using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;

public class camParent : MonoBehaviour
{
    public GameObject followObject;
    [SerializeField] private GameObject confettiObj;
    public bool followPosition;
   
    [ShowIf("followPosition", true)]public bool followXP;
    [ShowIf("followPosition", true)]public bool followYP;
    [ShowIf("followPosition", true)]public bool followZP;
    public bool followRotation;
    [ShowIf("followRotation", true)]public bool followXR;
    [ShowIf("followRotation", true)]public bool followYR;
    [ShowIf("followRotation", true)]public bool followZR;
    
    
    void LateUpdate()
    {
        if (followPosition)
        {
            Vector3 target = followObject.transform.position;
            if (!followXP)
            {
                target.x = this.transform.position.x;
            }

            if (!followYP)
            {
                target.y = this.transform.position.y;
            }

            if (!followZP)
            {
                target.z = this.transform.position.z;
            }
            
            this.transform.position =
                Vector3.Lerp(this.transform.position, target, Time.deltaTime * 5);
            
        }

        
        if (followRotation)
        {
            Quaternion tr = followObject.transform.rotation;
            if (!followXR)
            {
                tr.x = 0;
            }

            if (!followYR)
            {
                tr.y = 0;
            }

            if (!followZR)
            {
                tr.z = 0;
            }

            this.transform.rotation =
                Quaternion.Lerp(this.transform.rotation, tr, Time.deltaTime * 6);
        }
    }
}
