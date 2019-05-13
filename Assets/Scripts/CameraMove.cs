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

        // Move the camera.
        float x = Input.GetAxis("Horizontal");
        float y = Input.GetAxis("Elevation");
        float z = Input.GetAxis("Vertical");
		Vector3 move = new Vector3(x, y, z);

        float speed = moveSpeed * (Input.GetButton("Jump") ? 2.5f : 1.0f);

        transform.Translate(move * speed * Time.deltaTime);
	}
}
