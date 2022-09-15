using System;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;

public class enemyWarrior : MonoBehaviour
{
    public enum State
    {
        wait,
        shoot,
        dieSwim,
    }

    public State myState;

    public void SetState(State s)
    {
        myState = s;
        if (s == State.wait)
        {
            myAnim.SetInteger("animInt", 1);
        }
        else if(s == State.dieSwim)
        {
            
            splashParticleObj.SetActive(true);
            myAnim.SetInteger("animInt", 2);
            GetComponent<Rigidbody>().isKinematic = false;
            //  GetComponent<Collider>().enabled = false;
            //  this.transform.DOLocalMove(this.transform.localPosition + new Vector3(0, -6, 0), 1.5f).SetEase(Ease.InQuad);
        }
        else if (s == State.shoot)
        {
            StartMakeShoot();
        }
    }


    [SerializeField] private Animator myAnim;
    [SerializeField] private float shootDelay;
    [SerializeField] private GameObject bulletPrefab;
    [SerializeField] private Transform bulSpawnPoint;
    [SerializeField] private GameObject splashParticleObj;
    private float shootTimer;
    private heroCollider _heroCollider;

   

    public void TrigStay(Collider col)
    {
        print("ENEMY TRIG STAY");
        _heroCollider = col.gameObject.GetComponent<heroCollider>();
        SetState(State.shoot);

    }

    public void TrigExit(Collider col)
    {
        if (_heroCollider != null)
        {


            if (col.gameObject.layer == 10 && col.gameObject == _heroCollider.gameObject)
            {
                SetState(State.wait);
            }
        }
    }
    void StartMakeShoot()
    {
        Vector3 napr = (_heroCollider.transform.position - this.transform.position).normalized;
        this.transform.DOLookAt(napr, 0.3f).OnComplete(SHootAnim);
    }

    void SHootAnim()
    {
        myAnim.SetInteger("animInt",1);
    }
    
    public void MakeShoot()
    {
        GameObject c = Instantiate(bulletPrefab);
        c.transform.position = bulSpawnPoint.position;
        c.transform.forward = this.transform.forward;
        c.GetComponent<Rigidbody>().AddForce(this.transform.forward*20, ForceMode.Impulse);
    }

    public void FinishShoot()
    {
        myAnim.SetInteger("animInt", 0);
    }
    private void Update()
    {
        if (myState == State.shoot)
        {
            shootTimer += Time.deltaTime;
            if (shootTimer>shootDelay)
            {
                StartMakeShoot();
                shootTimer = 0;
            }

            if (_heroCollider._wtc.myState == watermanTestController.State.liquid)
            {
                SetState(State.wait);
            }
        }
    }
}
