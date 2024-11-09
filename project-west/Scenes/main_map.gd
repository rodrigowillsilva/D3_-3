extends Node3D

@onready var SM : SoundManager = get_tree().get_root().get_node("SoundManager")
@onready var Player : CharacterBody3D = $Player

func _ready() -> void:
	SM.category_stop(0)
	SM.category_finder(0,"MM2",false)
	Player.player_died.connect(func() -> void:
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
