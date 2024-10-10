extends CharacterBody3D


@export var health: float
@export var maxSpeed: float
@export var acceleration: float
@export var deceleration: float
@export var jumpHeight: float
@export var gravity: float
@export var sens: float
@export var gun_controller: GunController

var input_dir: Vector2


func _physics_process(delta: float) -> void:
	var velocity_xz = Vector3(velocity.x, 0, velocity.z)
	var velocity_y = Vector3(0, velocity.y, 0)

	# Add the gravity.
	if not is_on_floor():
		velocity_y += gravity * delta * Vector3(0, -1, 0)

	# Handle jump.
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity_y.y = sqrt(jumpHeight * 2.0 * gravity)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	print(transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity_xz = velocity_xz.move_toward(direction * maxSpeed, acceleration * delta)
	else:
		
		velocity_xz = velocity_xz.move_toward(Vector3(), deceleration * delta)

	velocity = velocity_xz + velocity_y

	move_and_slide()



func take_damage(damage: float) -> void:
	health -= damage
	# signal damage taken
	if health <= 0:
		# signal the player's death 
		pass


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
				#gun_controller.shoot_gun()
			elif event.is_action("mouse_2"):
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if event is InputEventKey:
		input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		
		if event.is_action_pressed("r"):
			gun_controller.reload_gun()
		elif event.is_action_pressed("mouse_scroll_up"):
			gun_controller.change_gun(-1)
		elif event.is_action_pressed("mouse_scroll_down"):
			gun_controller.change_gun(-2)
		
		#check if the player is pressing onw through four keys
		if event.pressed:
			if event.keycode > 49 and event.keycode < 49 + gun_controller.guns.size():
				gun_controller.change_gun(event.keycode - 49)

		
