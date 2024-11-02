extends Node3D

signal start_level
signal end_level

func _ready() -> void:
	
	end_level.connect(func() -> void:
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
		)
