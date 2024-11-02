extends CharacterBody3D

@onready var music_player = $"../Music"
@export var health: float
@export var max_speed: float
@export var accel: float
@export var decel: float
@export var jumpHeight: float
@export var gravity: float
@export var sens: float
@export var gun_controller: GunController
@export var r: Rope3D
@onready var audioplay = $"../Music"
@onready var audiosteps = $"../audio_steps"

var input_dir: Vector2

var gun_skill_phisics_process = func (_delta: float) -> void: pass

signal player_died

func _ready() -> void:
	$DamageAndLifeController.die_signal.connect(func() -> void:
		$"/root/GameManager".end_level.emit()
	)
	music_player.play()
	for gun in gun_controller.guns:
		if gun is Revolver:
			gun.skill_signal.connect(func() -> void:
				self.max_speed *= gun.speed_boost_percent
			)
			gun.on_unequip_signal.connect(func() -> void:
				self.max_speed /= gun.speed_boost_percent
			)
		
		if gun is Shotgun:
			gun.skill_signal.connect(func() -> void:
				gun_skill_phisics_process = func (_delta: float) -> void:
					var gc = gun_controller
					var cg = gc.current_gun as Shotgun
					var pull_force_modifier = pow((cg.hook.global_transform.origin - gc.global_transform.origin).length(), 1.0/3.0) 

					# pull the player towards the hook
					var pull_force: Vector3 = (cg.hook.global_transform.origin - gc.global_transform.origin).normalized() * pull_force_modifier
					
					velocity += pull_force * cg.pull_for_axis_mod
			)
			gun.stop_grapling_signal.connect(func() -> void:
				gun_skill_phisics_process = func (_delta: float) -> void: pass
			)
		
		if gun is Cross:
			gun.skill_signal.connect(func() -> void:
				$DamageAndLifeController.heal(gun.life_regen)
			)

		gun_controller.change_gun(0)
		gun_controller.anim_player.play("Revolver_show")


func _physics_process(delta: float) -> void:
	if Input.is_key_pressed(KEY_T):
		r.make()
	
	var velocity_xz = Vector3(get_real_velocity().x, 0, get_real_velocity().z)
	var velocity_y = Vector3.ZERO
	if get_real_velocity().abs().y < 3:
		velocity_y = Vector3(0, velocity.y, 0)
	else:
		velocity_y = Vector3(0, get_real_velocity().y, 0)
	
	# Add the gravity.
	
	# Assuming get_wall_normal() returns the wall normal
	if not is_on_floor():
		var wall_normal = get_wall_normal().normalized()
		# Define the down vector
		var down_vector = Vector3(0, -1, 0)
		# Project the down vector onto the plane defined by the wall normal
		var tangent_vector = (down_vector - wall_normal * down_vector.dot(wall_normal)).normalized()
		#print(tangent_vector)

		velocity_y += gravity * delta * tangent_vector
	#velocity_y += gravity * delta * Vector3(0, -1, 0)

	# Handle jump.
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity_y.y = sqrt(jumpHeight * 2.0 * gravity)
	
	var air_mod = 1
	if not is_on_floor():
		air_mod = 0.5

	# print(transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		if velocity_xz.length() <= max_speed and direction.dot(velocity_xz.normalized()) >= 0:
			velocity_xz = velocity_xz.move_toward(direction * max_speed, delta * air_mod * accel)
		else:
			velocity_xz = velocity_xz.move_toward(Vector3.ZERO, delta * air_mod * decel)
	else:
		velocity_xz = velocity_xz.move_toward(Vector3.ZERO, delta * air_mod * decel)
	

	velocity_xz = velocity_xz.clamp(-2 * max_speed * Vector3.ONE, 2 * max_speed * Vector3.ONE)

	
	
	velocity = velocity_xz + velocity_y

	gun_skill_phisics_process.call(delta)
	
	# Clamp the velocity to the 2 * max_speed
	
	
	move_and_slide()

func take_damage(damage_type: Enums.DamageType, damage: int):
	if damage_type != Enums.DamageType.ENEMY: return
	
	$DamageAndLifeController.take_damage(damage_type, damage)

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
		
		if event.is_action_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
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
	if velocity != Vector3.ZERO:
		audiosteps.play()
	else:
		velocity == Vector3.ZERO
		audiosteps.stop()

func _on_music_finished() -> void:
	audioplay.play()
