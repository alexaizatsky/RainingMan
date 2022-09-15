using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class liquidTrigger : MonoBehaviour
{
    private void OnTriggerEnter(Collider col)
    {
        if (col.gameObject.layer == 11)
        {
            //    col.gameObject.transform.SetParent(this.transform.parent);
            col.gameObject.layer = 23;
            col.gameObject.GetComponent<enemyWarrior>().SetState(enemyWarrior.State.dieSwim);
        }
        else if(col.gameObject.layer == 22)
        {
            col.gameObject.layer = 23;
            col.GetComponent<Rigidbody>().isKinematic = false;
        }
    }

    private void OnTriggerExit(Collider col)
    {
        if(col.gameObject.layer == 23)
            col.gameObject.layer = 22;  
    }
}
