extends Node3D

class_name SpawnController

@export var pool_point : Marker3D
@export var player: Node3D
var spawnpoints : Array[SpawnPoint]
var enemy_pool : Array[BasicEnemy]
var enemy_control : Array[bool] 
var timer : Timer
var spawning : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not spawning: return

	var sp = get_children()
	for child in sp:
		if child is SpawnPoint:
			spawnpoints.append(child)
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(on_timer_timeout)
	var enemy : Array[PackedScene]
	enemy.append(load("res://Scenes/basic_enemy.tscn"))
	for e in enemy:
		for i in range (10):
			var spawn_enemy = e.instantiate()
			#spawn_enemy.set_process(false)
			#spawn_enemy.set_physics_process(false)
			#spawn_enemy.set_process_input(false)
			spawn_enemy.activated = false
			spawn_enemy.position = pool_point.position
			spawn_enemy.spawnController = self
			enemy_control.append(true)
			enemy_pool.append(spawn_enemy)
			spawn_enemy.died.connect(enemy_died)
			get_tree().get_root().get_node("/root/GrayBox").add_child.call_deferred(spawn_enemy)
	timer.start(3)
	pass

func _physics_process(delta):
	for enemy in enemy_pool:
		if enemy.activated:
			enemy.nav_agent.set_target_position(enemy.player.global_transform.origin)
			enemy.next_nav_point = enemy.nav_agent.get_next_path_position()
			
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func pick_enemy():
	var index = randi_range(0, 9)
	while not enemy_control[index]:
		index = randi_range(0, 9)
	enemy_control[index] = false
	
	return enemy_pool[index]
	
func on_timer_timeout():
	if enemy_control.all(func(x) : return x == false) : 
		timer.start()
		return 
	var which_enemy = pick_enemy()
	print(which_enemy)
	which_enemy.position = spawnpoints.pick_random().position + Vector3(0,1,0)
	which_enemy.activated = true
	which_enemy.spawn()
	timer.start()

func enemy_died(enemy : BasicEnemy):
	var index = enemy_pool.find(enemy)
	enemy_control[index] = true
	enemy.position = pool_point.position
	enemy.activated = false
	timer.start()
	pass
