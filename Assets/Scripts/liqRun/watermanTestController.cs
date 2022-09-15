using System;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;

public class watermanTestController : MonoBehaviour
{
    [SerializeField] private bool runControl;
    [SerializeField] private Material liquidMaterial;
    [SerializeField] private Animator heroAnim;
    [SerializeField] private meshAnimation _meshAnimation;
    
    [SerializeField] private float turnAngle;

    [SerializeField] private GameObject heroColliderObj;
    [SerializeField] private GameObject liqTriggerObj;
    public enum State
    {
        human,
        liquid,
    }

    public State myState;

    private Vector3 newPos;
    private float moveSpeed = 0.4f;
    private Vector3 startTouchEul, newEul;
    private Vector3 xOffset;
    private Tween delayTween;
    private void Start()
    {
        if (GetComponent<mainCarInput>()!=null)
        {
            mainCarInput mci = GetComponent<mainCarInput>();
            mci.OnStartTouch += StartTouch;
            mci.OnTouchUpdate+=TouchUpdate;
            mci.OnTouchEnd += EndTouch;
        }
        SetState(State.liquid);
    }

    void StartTouch()
    {
        startTouchEul = this.transform.eulerAngles;
        if (myState == State.liquid)
        {
            SetState(State.human);
        }
        xOffset = Vector3.zero;
    }

    void TouchUpdate(Vector2 _input)
    {
        if (runControl)
        {
            xOffset = new Vector3( Mathf.Lerp(-1, 1, Mathf.InverseLerp(-1, 1, _input.x)), 0,0);
        }
        else
        {
            newEul = startTouchEul + new Vector3(0, _input.x * turnAngle, 0);
            this.transform.eulerAngles = newEul;
            xOffset = Vector3.zero;
        }
    }

    void EndTouch()
    {
        if (myState == State.human)
        {
            SetState(State.liquid);
            _meshAnimation.ChangeReverse();
        } 
        xOffset = Vector3.zero;
        
    }
    void SetState(State s)
    {
        myState = s;
        if (s == State.liquid)
        {
            heroAnim.SetInteger("animInt",0);
          if(delayTween!=null)
              delayTween.Kill();
          delayTween =  DOVirtual.DelayedCall(0.1f, DelayOffAnimObj);
           liqTriggerObj.SetActive(true);
           heroColliderObj.SetActive(false);
            moveSpeed = 0;
          //  _meshAnimation.ChangeReverse();
            // _meshAnimation.PlayAnimation();
        }
        else if(s == State.human)
        {
            liqTriggerObj.SetActive(false);
            heroColliderObj.SetActive(true);
            ChangeWaterEffect(false);
            _meshAnimation.ChangeReverse();
            if(delayTween!=null)
                delayTween.Kill();
         delayTween =  DOVirtual.DelayedCall(0.5f, DelayOnAnimObj);
        }
    }

    void DelayOffAnimObj()
    {
        heroAnim.gameObject.SetActive(false);
        _meshAnimation.gameObject.SetActive(true);
    //    _meshAnimation.gameObject.SetActive(true);
        _meshAnimation.PlayAnimation();
        ChangeWaterEffect(true);
    }

    void DelayOnAnimObj()
    {
        heroAnim.gameObject.SetActive(true);
        heroAnim.SetInteger("animInt",1);
        _meshAnimation.gameObject.SetActive(false);
    }


    void ChangeWaterEffect(bool _apply)
    {
        if (_apply)
        {
            liquidMaterial.SetFloat("_HeightAmount", 0.3f);
        }
        else
        {
            liquidMaterial.SetFloat("_HeightAmount", 0f);
        }
    }
    private void Update()
    {
        if (moveSpeed < 0.4f)
            moveSpeed += Time.deltaTime*0.3f;

        float c = 1;
        if (myState == State.liquid)
            c = 0.5f;
        
        newPos = this.transform.position+ this.transform.forward * (moveSpeed*c) + xOffset;
       this.transform.position = Vector3.Lerp(this.transform.position, newPos, Time.deltaTime * 20);
        
       
    }
}
