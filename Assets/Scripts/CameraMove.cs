using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraMove : MonoBehaviour
{
	private const float moveSpeed = 7.5f;
	private const float cameraSpeed = 3.0f;

	private Vector2 rotation = Vector2.zero;

	private void Awake()
	{
		Cursor.lockState = CursorLockMode.Locked;
	}

	private void Update()
	{
		// Rotate the camera.
		rotation += new Vector2(-Input.GetAxis("Mouse Y"), Input.GetAxis("Mouse X"));
		transform.eulerAngles = rotation * cameraSpeed;

		Vector3 move = new Vector3(Input.GetAxis("Horizontal"), 0.0f, Input.GetAxis("Vertical"));
		transform.Translate(move * moveSpeed * Time.deltaTime);
	}
}
