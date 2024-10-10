extends Marker3D
class_name SpawnPoint

@export var enemy_types : Array[String]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func choose_enemy() -> String:
	return enemy_types.pick_random()
	
