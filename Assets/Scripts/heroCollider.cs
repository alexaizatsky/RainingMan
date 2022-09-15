using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class heroCollider : MonoBehaviour
{
    public watermanTestController _wtc;
    public LayerMask lm;
    public bool ChechIfISeeThisEnemy(GameObject _enemy)
    {
        bool ret = false;
        RaycastHit hit;
        if (Physics.Raycast(this.transform.position, this.transform.forward, out hit, lm))
        {
            print("SPHERCAST "+hit.collider.gameObject.name);
            if (hit.collider.gameObject.layer == 11)
            {
              //  if (hit.collider.gameObject == _enemy)
              //  {
                    ret = true;
              //  }
            }
        }
        print("CHECK SEE ENEMY "+ret);
        return ret;
    }
}
