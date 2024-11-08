extends Node3D

@onready var SM : SoundManager = get_tree().get_root().get_node("SoundManager")

func _ready() -> void:
	SM.category_stop(0)
	SM.category_finder(0,"MM2",false)
	
