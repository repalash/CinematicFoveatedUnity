using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GuidePath : MonoBehaviour {

	public Material mat;
	public Camera cam;

	void Start()
	{
	}

	void Update()
	{
		Vector3 screenPos = cam.WorldToScreenPoint(transform.position);
		screenPos.x /= Screen.width/2;
		screenPos.y /= Screen.height;
//		print(screenPos);
		mat.SetVector("_BlurMaskCenter", new Vector4(screenPos.x, screenPos.y, screenPos.z, 0.0f));
	}

}
