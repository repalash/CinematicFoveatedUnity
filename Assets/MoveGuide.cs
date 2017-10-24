using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveGuide : MonoBehaviour
{

	public int speed;
	
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		speed = Math.Max(-360, Math.Min(360, speed));
		transform.eulerAngles = new Vector3(0, transform.eulerAngles.y+speed * Time.deltaTime, 0);
	}
}
