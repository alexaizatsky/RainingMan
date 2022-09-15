using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class enemyAnim : MonoBehaviour
{
    [SerializeField] private enemyWarrior _enemyWarrior;
    
    public void MakeShoot()
    {
        _enemyWarrior.MakeShoot();
    }

    public void FinishShoot()
    {
        _enemyWarrior.FinishShoot();
    }
}
