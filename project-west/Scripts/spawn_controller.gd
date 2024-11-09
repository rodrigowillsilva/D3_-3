extends Node3D

class_name SpawnController

@export var pool_point : Marker3D
@export var player: Node3D
@export var initial_spawn_speed: float
@export var quantidade_inimigos : int
var spawnpoints : Array[SpawnPoint]
var enemy_pool : Array[BasicEnemy]
var enemy_control : Array[bool] 
var timer : Timer
var timerSpawn : Timer
var spawning : bool = true
var inimigos_mortos : int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not spawning: return

	var sp = get_children()
	for child in sp:
		if child is SpawnPoint:
			spawnpoints.append(child)
	timer = Timer.new()
	timerSpawn = Timer.new()
	add_child(timer)
	add_child(timerSpawn)
	timer.timeout.connect(on_timer_timeout)
	timerSpawn.timeout.connect(on_spawn_timeout)
	var enemy : Array[PackedScene]
	enemy.append(load("res://Scenes/basic_enemy.tscn"))
	enemy.append(load("res://Scenes/Enemy2.tscn"))
	enemy.append(load("res://Scenes/BasicEnemy3.tscn"))
	enemy.append(load("res://Scenes/BasicEnemy4.tscn"))
	for e in enemy:
		for i in range(quantidade_inimigos):
			var r = enemy.pick_random()
			var spawn_enemy = r.instantiate()
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
	timer.start(initial_spawn_speed)
	timerSpawn.start(30)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func pick_enemy():
	for i in range(quantidade_inimigos):
		if enemy_control[i]:
			enemy_control[i] = false
			return enemy_pool[i]

	# If all elements are false, return null or handle this case as needed
	print("All enemies have been used.")
	return null

func on_spawn_timeout():
	if(initial_spawn_speed > 1.0):
		initial_spawn_speed -= 0.5

func on_timer_timeout():
	#print("spean")
	if enemy_control.all(func(x) : return x == false) : 
		timer.start()
		return 
	var which_enemy : BasicEnemy = pick_enemy()
	
	if(which_enemy == null):
		timer.start(initial_spawn_speed)
		return
	#print(which_enemy)
	which_enemy.position = spawnpoints.pick_random().position + Vector3(0,1,0)
	which_enemy.activated = true
	which_enemy.set_deferred("process_mode", PROCESS_MODE_PAUSABLE)
	which_enemy.spawn()
	
	timer.start(initial_spawn_speed)

func enemy_died(enemy : BasicEnemy):
	var index = enemy_pool.find(enemy)
	enemy_control[index] = true
	enemy.position = pool_point.position
	enemy.activated = false
	enemy.set_deferred("process_mode", PROCESS_MODE_DISABLED)
	inimigos_mortos += 1
	timer.start()
	pass
