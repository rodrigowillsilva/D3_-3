extends CharacterBody3D
class_name BasicEnemy

var gravity = 20
var activated := true

@export var state_machine : Node3D
@export var attack_range : float
@export var health : float
@export var SPEED : float
@export var player: Node3D

var mov: Vector3
var nav_timer: Timer
var next_nav_point: Vector3 = Vector3.ZERO
var spawnController: SpawnController

signal died(enemy: BasicEnemy)

var map_ready = false
# Called when the node enters the scene tree for the first time.
func _ready():
	#state_machine = anim.tree.get("parametes/playback")
	if player == null: 
		player = spawnController.player

	NavigationServer3D.map_changed.connect(func(_map): map_ready = true)
	$DamageAndLifeController.max_health - health
	$DamageAndLifeController.die_signal.connect(die)
	nav_timer = Timer.new()
	add_child(nav_timer)
	nav_timer.timeout.connect(func(): 
		$NavigationAgent3D.set_target_position(player.global_transform.origin)
		
	)
	nav_timer.start(0.1)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not map_ready: return
	if not activated: return

	# $NavigationAgent3D.set_target_position(player.global_transform.origin)
	# next_nav_point = $NavigationAgent3D.get_next_path_position()

	#var movement: Vector3 = next_nav_point - global_position
	#print(movement)
	#if movement.length() > 0.5:
		#movement = movement.normalized() * SPEED
		#transform.origin.x += movement.x * delta
		#transform.origin.z += movement.z * delta

	next_nav_point = $NavigationAgent3D.get_next_path_position()
	mov = next_nav_point - global_position
	$NavigationAgent3D.set_velocity(mov.normalized() * SPEED)
	#if movement.length() > 0.5:
	
		
	#velocity = -transform.basis.z
	
	move_and_slide()



func die():
	died.emit(self)	
	
	
func move(movement):
	pass
	
func spawn():
	$DamageAndLifeController.spawn()

func take_damage(damage_type: Enums.DamageType, damage: int):
	$DamageAndLifeController.take_damage(damage_type, damage)
	
func _target_in_range():
	return global_position.distance_to(player.global_position) < attack_range
	

func _hit_finished():
	if global_position.distance_to(player.global_position) < attack_range + 1.0:
		var dir = global_position.direction_to(player.global_position)
		player.hit(dir)
	#adicionar o player_hit_signal no script do player 
func hit():
	pass
	


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	if not $NavigationAgent3D.is_target_reached():
		velocity = safe_velocity
	pass # Replace with function body.
