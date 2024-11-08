extends Node3D

class_name SpawnController

@export var pool_point : Marker3D
@export var player: Node3D
@export var initial_spawn_speed: int
@export var spawn_curve: Curve
var spawnpoints : Array[SpawnPoint]
var enemy_pool : Array[BasicEnemy]
var enemy_control : Array[bool] 
var timer : Timer
var spawning : bool = true


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
			spawn_enemy.player = $"../Player"
			spawn_enemy.set_deferred("process_mode", PROCESS_MODE_DISABLED)
			spawn_enemy.position = pool_point.position
			spawn_enemy.spawnController = self
			enemy_control.append(true)
			enemy_pool.append(spawn_enemy)
			spawn_enemy.died.connect(enemy_died)
			get_parent().add_child.call_deferred(spawn_enemy)
	timer.start(3)
	
	

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
	print("spean")
	if enemy_control.all(func(x) : return x == false) : 
		timer.start()
		return 
	var which_enemy = pick_enemy()
	print(which_enemy)
	which_enemy.position = spawnpoints.pick_random().position + Vector3(0,1,0)
	which_enemy.activated = true
	which_enemy.set_deferred("process_mode", PROCESS_MODE_PAUSABLE)
	which_enemy.spawn()
	timer.start()

func enemy_died(enemy : BasicEnemy):
	var index = enemy_pool.find(enemy)
	enemy_control[index] = true
	enemy.position = pool_point.position
	enemy.activated = false
	enemy.set_deferred("process_mode", PROCESS_MODE_DISABLED)
	timer.start()
	pass
