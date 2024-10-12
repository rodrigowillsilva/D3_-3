extends Node3D
class_name BasicEnemy

########################################################################################
# parte do código utilizada para o inimigo seguir o player
# no export player path, o NodePath é o node do playerMovement.

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var activated := true

@export var state_machine : Node3D
@export var attack_range : float
@export var health : float
@export var SPEED : float


@export var player: Node3D
#
@onready var nav_agent = $NavigationAgent3D
@onready var damage_control : DamageAndLifeController = $DamageAndLifeController

var nav_timer: Timer
var next_nav_point: Vector3 = Vector3.ZERO

signal died(enemy: BasicEnemy)

#######################################################################################
var map_ready = false
# Called when the node enters the scene tree for the first time.
func _ready():
	#state_machine = anim.tree.get("parametes/playback")
	player = get_node("../Player")
	NavigationServer3D.map_changed.connect(func(_map): map_ready = true)
	damage_control.die_signal.connect(die)
	# nav_timer = Timer.new()
	# add_child(nav_timer)
	# nav_timer.timeout.connect(func(): 
	# 	nav_agent.set_target_position(player.global_transform.origin)
	# 	next_nav_point = nav_agent.get_next_path_position())
	# nav_timer.start(0.1)
	#player = get_node(player_path)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not map_ready: return
	if not activated: return
	
	# match state_machine.get_current_node():
	# 	"Run":
	#navigation
	
	#dvar next_nav_point = nav_agent.get_next_path_position()
	
	#look_at(Vector3(global_position.x + velocity.x, global_position.y, global_position.z + velocity.z), Vector3.UP)
		# "Attack":
		# 	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	nav_agent.set_target_position(player.global_transform.origin)
	next_nav_point = nav_agent.get_next_path_position()

	var movement: Vector3 = next_nav_point - global_position
	print(movement)
	if movement.length() > 0.5:
		movement = movement.normalized() * SPEED
		transform.origin.x += movement.x * delta
		transform.origin.z += movement.z * delta
	#conditions
	#anim_tree.set("parameters/conditions/attack", _target_in_range())
	#anim_tree.set("parameters/conditions/run", !_target_in_range())
	#
	#anim_tree.get("parameters/playback")
	
	#move_and_slide()


func die():
	died.emit(self)	
	
	
func move(movement):
	pass
	
func spawn():
	damage_control.spawn()

func take_damage(damage_type: Enums.DamageType, damage: int):
	damage_control.take_damage(damage_type, damage)
	
func _target_in_range():
	return global_position.distance_to(player.global_position) < attack_range
	

func _hit_finished():
	if global_position.distance_to(player.global_position) < attack_range + 1.0:
		var dir = global_position.direction_to(player.global_position)
		player.hit(dir)
	#adicionar o player_hit_signal no script do player 
func hit():
	pass
	
