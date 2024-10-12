extends Node3D

@export var pool_point : Marker3D
var spawnpoints : Array[SpawnPoint]
var enemy_pool : Array[BasicEnemy]
var enemy_control : Array[bool] 
var timer : Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sp = get_children()
	for child in sp:
		if child is SpawnPoint:
			spawnpoints.append(child)
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(on_timer_timeout)
	var enemy : Array[PackedScene]
	enemy.append(load("res://Scenes/enemies/basic_enemy.tscn"))
	for e in enemy:
		for i in range (10):
			var spawn_enemy = e.instantiate()
			spawn_enemy.set_process(false)
			spawn_enemy.set_physics_process(false)
			spawn_enemy.set_process_input(false)
			spawn_enemy.position = pool_point.position
			enemy_control.append(true)
			enemy_pool.append(spawn_enemy)
			add_child(spawn_enemy)
	timer.start()


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
		return 
	var which_enemy = pick_enemy()
	print(which_enemy)
	which_enemy.position = spawnpoints.pick_random().position
	timer.start()
