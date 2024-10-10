extends CharacterBody3D
class_name BasicEnemy
#
#########################################################################################
## parte do código utilizada para o inimigo seguir o player
## no export player path, o NodePath é o node do playerMovement.
#
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
#
#var player = null
#@export var state_machine : Node3D
#@export var attack_range : float
#@export var health : float
#@export var SPEED : float
#@onready var anim = $AnimationTree
#
#
#@export var player_path : NodePath
##
#@onready var nav_agent = $NavigationAgent3D
#
#
########################################################################################
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	#state_machine = anim.tree.get("parametes/playback")
	#
	#player = get_node(player_path)
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta):
	#match state_machine.get_current_node():
		#"Run":
			##navigation
			#velocity.y -= gravity * delta
			#
			#velocity = Vector3.ZERO
			#nav_agent.set_target_position(player.global_transform.origin)
			#var next_nav_point = nav_agent.get_next_path_position()
			#velocity = (next_nav_point - global_transform.origin).normalized() * SPEED 
			#look_at(Vector3(global_position.x + velocity.x, global_position.y, global_position.z + velocity.z), Vector3.UP)
		#"Attack":
			#look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
#
	#
#
	#
	##conditions
	##anim_tree.set("parameters/conditions/attack", _target_in_range())
	##anim_tree.set("parameters/conditions/run", !_target_in_range())
	##
	##anim_tree.get("parameters/playback")
	#
	#move_and_slide()
#
	#
	#
#func move(movement):
	#pass
	#
	#
#func take_damage() -> void:
	#pass
	#
#func _target_in_range():
	#return global_position.distance_to(player.global_position) < attack_range
	#
#
#func _hit_finished():
	#if global_position.distance_to(player.global_position) < attack_range + 1.0:
		#var dir = global_position.direction_to(player.global_position)
		#player.hit(dir)
	##adicionar o player_hit_signal no script do player 
#func hit():
	#pass
	#
