extends CharacterBody3D


@export var health: float
@export var maxSpeed: float
@export var acceleration: float
@export var deceleration: float
@export var jumpHeight: float
@export var gravity: float
@export var sens: float

var input_dir: Vector2



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += gravity * delta * Vector3(0, -1, 0)

	# Handle jump.
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = sqrt(jumpHeight * 2.0 * gravity)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity = velocity.move_toward(direction * maxSpeed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector3(), deceleration * delta)

	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Apply sensitivity directly to the raw input
		var delta_x = -event.relative.x * sens * 0.005
		var delta_y = -event.relative.y * sens * 0.005
				
		# Rotate the player and camera
		rotate_y(delta_x)
		$PlayerCamera.rotate_x(delta_y)
				
		# Clamp the camera rotation to avoid flipping
		var camera_rotation = $PlayerCamera.rotation_degrees
		camera_rotation.x = clamp(camera_rotation.x, -80, 80)
		$PlayerCamera.rotation_degrees = camera_rotation
		
		
	elif event is InputEventMouseButton:
		if event.is_pressed():
			if event.is_action("mouse_1"):
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			elif event.is_action("mouse_2"):
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if event is InputEventKey:
		input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
