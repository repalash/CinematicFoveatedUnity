using System;
using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class CameraBlurPost : MonoBehaviour {

	public float intensity;
	public Material material;

	[SerializeField]
	private int speed;

	// Postprocess the image
	void OnRenderImage (RenderTexture source, RenderTexture destination)
	{
		Graphics.Blit (source, destination, material);
	}

	private void Update()
	{
//		speed = Math.Max(-360, Math.Min(360, speed));
//		transform.eulerAngles = new Vector3(0, transform.eulerAngles.y+speed * Time.deltaTime, 0);
	}
}

