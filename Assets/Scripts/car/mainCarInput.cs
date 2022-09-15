using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public delegate void TouchUpdateCar(Vector2 _input);

public delegate void TouchStartCar();

public delegate void TouchEndCar();
public class mainCarInput : MonoBehaviour
{
    public event TouchUpdateCar OnTouchUpdate;
    public event TouchStartCar OnStartTouch;
    public event TouchEndCar OnTouchEnd;
    private Vector2 startPos, dragPos, raznica;
    
    private bool pressed;
    
    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            if (!pressed)
            {
                pressed = true;
                startPos = Input.mousePosition;
            }

            if (OnStartTouch != null)
                OnStartTouch();
        }

        if (Input.GetMouseButton(0))
        {
            if (pressed)
            {
                dragPos = Input.mousePosition;
                raznica = dragPos - startPos;
                float xc = Mathf.Lerp(-1, 1, Mathf.InverseLerp(-Screen.width , Screen.width, raznica.x));
                float yc = Mathf.Lerp(-1, 1, Mathf.InverseLerp(-Screen.height, Screen.height, raznica.y));
                if (OnTouchUpdate!=null)
                {
                    OnTouchUpdate(new Vector2(xc,yc));
                }
            }
        }

        if (Input.GetMouseButtonUp(0))
        {
            if (pressed)
            {
                pressed = false;
                startPos = Vector2.zero;
                dragPos = Vector2.zero;
                raznica = Vector2.zero;
                if (OnTouchEnd != null)
                    OnTouchEnd();
            }
        }
    }
}
