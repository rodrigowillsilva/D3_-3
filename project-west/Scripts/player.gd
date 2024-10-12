extends CharacterBody3D


@export var health: float
@export var max_speed: float
@export var accel: float
@export var decel: float
@export var jumpHeight: float
@export var gravity: float
@export var sens: float
@export var gun_controller: GunController

var input_dir: Vector2

var gun_skill_phisics_process = func (_delta: float) -> void: pass

func _ready() -> void:
	for gun in gun_controller.guns:
		if gun is Revolver:
			gun.skill_signal.connect(func() -> void:
				self.max_speed *= gun.speed_boost_percent
				print("Revolver skill")
			)
			gun.on_unequip_signal.connect(func() -> void:
				self.max_speed /= gun.speed_boost_percent
			)
		
		if gun is Shotgun:
			gun.skill_signal.connect(func() -> void:
				print("Shotgun skill")
				gun_skill_phisics_process = func (_delta: float) -> void:
					var gc = gun_controller
					var cg = gc.current_gun as Shotgun
					var pull_force_modifier = pow((cg.hook.global_transform.origin - gc.global_transform.origin).length(), 1.0/3.0) 

					# pull the player towards the hook
					var pull_force: Vector3 = (cg.hook.global_transform.origin - gc.global_transform.origin).normalized() * pull_force_modifier
					
					velocity += pull_force * cg.pull_for_axis_mod
			)
			gun.stop_grapling_signal.connect(func() -> void:
				print("Shotgun stop skill")
				gun_skill_phisics_process = func (_delta: float) -> void: pass
			)

		gun_controller.change_gun(0)
			


func _physics_process(delta: float) -> void:
	var velocity_xz = Vector3(velocity.x, 0, velocity.z)
	var velocity_y = Vector3(0, velocity.y, 0)

	# Add the gravity.
	if not is_on_floor():
		velocity_y += gravity * delta * Vector3(0, -1, 0)

	# Handle jump.
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity_y.y = sqrt(jumpHeight * 2.0 * gravity)
	
	var air_mod = 1
	if not is_on_floor():
		air_mod = 0.5

	# print(transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()


	if direction:
		if velocity_xz.length() < max_speed:
			velocity_xz = velocity_xz.move_toward(direction * max_speed, delta * air_mod * accel)
		else:
			velocity_xz = velocity_xz.move_toward(Vector3.ZERO, delta * air_mod * decel)
	else:
		velocity_xz = velocity_xz.move_toward(Vector3.ZERO, delta * air_mod * decel)
	
	# else:	
	# 	velocity_xz = velocity_xz.move_toward(Vector3(), deceleration * delta)

	velocity_xz = velocity_xz.clamp(-2 * max_speed * Vector3.ONE, 2 * max_speed * Vector3.ONE)

	velocity = velocity_xz + velocity_y

	gun_skill_phisics_process.call(delta)
	
	# Clamp the velocity to the 2 * max_speed
	
	
	move_and_slide()


# func velocity_accel(v_0: Vector3, direction: Vector3, delta: float) -> Vector3:
# 	""" Given a positive initial 2D velocity and a delta time, return a positive
# 	new velocity based on a custom 'game-feel' curve.
# 	"""
# 	#v_0 = clamped(v_0)

# 	# Map to [0,1] to simplify
# 	var speed = v_0.length() / max_speed

# 	# Derive where we are in time [0,1] based on current speed
# 	var t: float = 1 - sqrt(1 - speed)
# 	if is_nan(t):
# 		# speed is 1, so t is 1
# 		t = 1
# 	var t_new: float = t + (delta/t_accel)

# 	# Calculate speed based on new t
# 	if t_new >= 1:
# 		return direction.normalized() * max_speed
# 	var speed_new: float = clamp(1 - (1-t_new)*(1-t_new), 0 ,1)
# 	return direction.normalized() * speed_new * max_speed


# func velocity_decel(v_0: Vector3, delta: float) -> Vector3:
# 	""" Given a positive initial 2D velocity and a delta time, return a new positive
# 	velocity that is slower, based on the Player's parameters.
# 	"""
# 	var speed = v_0.length() / max_speed
# 	var t: float = 1 - sqrt(speed)
# 	if is_nan(t):
# 		t = 1
# 	var t_new: float = t + (delta/t_decel)
# 	if t_new >= t_decel:
# 		return Vector3()
# 	var speed_new = clamp((1-t_new)*(1-t_new), 0, 1)
# 	return v_0.normalized() * speed_new * max_speed

# func clamped(v: Vector3) -> Vector3:
# 	return v.clamp(-max_speed * Vector3.ONE, max_speed * Vector3.ONE)


func take_damage(damage: float) -> void:
	health -= damage
	# signal damage taken
	if health <= 0:
		# signal the player's death 
		pass

#Callbacks 

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Apply sensitivity directly to the raw input
		var delta_x = -event.relative.x * sens * 0.005
		var delta_y = -event.relative.y * sens * 0.005
				
		# Rotate the player and camera
		rotate_y(delta_x)
		$Head.rotate_x(delta_y)
				
		# Clamp the camera rotation to avoid flipping
		var camera_rotation = $Head.rotation_degrees
		camera_rotation.x = clamp(camera_rotation.x, -80, 80)
		$Head.rotation_degrees = camera_rotation
		
		
	elif event is InputEventMouseButton:
		if event.is_pressed():
			if event.is_action("mouse_1"):
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				gun_controller.shoot_gun()
			elif event.is_action("mouse_2"):
				gun_controller.use_skill()

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
			if event.keycode >= 49 and event.keycode < 49 + gun_controller.guns.size():
				gun_controller.change_gun(event.keycode - 49)

		
