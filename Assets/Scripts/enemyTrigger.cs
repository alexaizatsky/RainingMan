using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class enemyTrigger : MonoBehaviour
{
    [SerializeField] private enemyWarrior _enemyWarrior;
    private void OnTriggerStay(Collider col)
    {
        if (col.gameObject.layer == 10)
        {
            print("HERO ENTER TRIGGER "+col.gameObject.name);
            if (col.gameObject.GetComponent<heroCollider>().ChechIfISeeThisEnemy(this.gameObject) && _enemyWarrior.myState == enemyWarrior.State.wait)
            {
               _enemyWarrior.TrigStay(col);
            }
        }
    }

    private void OnTriggerExit(Collider col)
    {
        _enemyWarrior.TrigExit(col);
        
    }
}
