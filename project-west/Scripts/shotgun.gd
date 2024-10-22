extends Gun

class_name Shotgun

@export var spread: float = 0.1
@export var pellets: int = 5
@export var grapiling_max_dist: int = 100
@export var grapling_speed: int = 75
@export var pull_for_axis_mod: Vector3 = Vector3(1, 0.7, 1)
@export var max_grapling_time: float = 1.5
@export var hit_placeholder: Array[Node3D]

var grapling: bool = false	
var grapling_dir: Vector3
var hook: Node3D
var current_grapling_speed: int
var grapling_timer: Timer

signal stop_grapling_signal

func _ready() -> void:
	super()
	grapling_timer = Timer.new()
	add_child(grapling_timer)
	grapling_timer.one_shot = true
	grapling_timer.timeout.connect(func() -> void:
		print("stop_grapling")
		stop_grapling()
	)	
	$Hook.visible = false
	$Hook.global_transform.origin = Vector3(0, 0, 0)
	$Hook.global_transform.basis = Basis()
	$Hook/CollisionShape3D.disabled = true
	$Hook.body_entered.connect(func(_body: Node3D) -> void:
		skill_signal.emit()
		current_grapling_speed = 0
	)
	hook = $Hook

func _physics_process(delta: float) -> void:
	if grapling:
		$Hook.global_transform.origin += grapling_dir * delta * current_grapling_speed

		if ($Hook.global_transform.origin - global_transform.origin).length() > grapiling_max_dist:
			stop_grapling()
		
			
func shoot() -> Enums.GunShootReturn:
	var r = super()
	if r != Enums.GunShootReturn.SHOOT:
		return r

	for i in range(pellets):
		var dir = transform.basis.z + Vector3(randf_range(-spread, spread), randf_range(-spread, spread), randf_range(-spread, spread))
		
		$GunRay.target_position = dir * -1 * 10000
		$GunRay.force_update_transform()
		$GunRay.force_raycast_update()
		if $GunRay.is_colliding():
			var body = $GunRay.get_collider()
			if body != null:
				var damage_controller = body.get_children().find(DamageAndLifeController)
				print(damage_controller)
				if damage_controller != -1:
					body.take_damage(Enums.DamageType.BULLET, 1)
					hit_placeholder[i].global_transform.origin = $GunRay.get_collision_point()
				else:
					print(body.get_name())
					hit_placeholder[i].global_transform.origin = $GunRay.get_collision_point()


	return Enums.GunShootReturn.SHOOT


func skill() -> void:
	#print(can_skill)
	if not can_skill: return
	start_grapling()
	can_skill = false

	
func _unhandled_input(event: InputEvent) -> void:
	if grapling:
		if event is InputEventMouseButton:
			if event.is_released():
				if event.is_action("mouse_2"):
					stop_grapling()


func start_grapling() -> void:
	grapling = true
	grapling_dir = -get_global_transform().basis.z.normalized()
	$Hook.visible = true
	$Hook.global_transform.origin = global_transform.origin
	$Hook.global_transform.basis = global_transform.basis
	$Hook/CollisionShape3D.disabled = false
	current_grapling_speed = grapling_speed
	grapling_timer.start(max_grapling_time)

func stop_grapling() -> void:
	$Hook.visible = false
	grapling = false
	$Hook/CollisionShape3D.disabled = true
	stop_grapling_signal.emit()
	timers[Enums.TimerType.SKILLCOOLDOWN].start(skill_cooldown)


func on_unequip() -> void:
	super()
	stop_grapling()

func on_equip() -> void:
	super()
	
