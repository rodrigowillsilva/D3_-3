extends Control

@onready var SM : SoundManager = get_tree().get_root().get_node("SoundManager")

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	SM.category_finder(0,"MM1",false)

func _on_play_pressed() -> void:
	print("Play pressed")
	get_tree().change_scene_to_file("res://Scenes/main_map.tscn")
	
	pass


func _on_quit_pressed() -> void:
	get_tree().quit()
	print("Quit pressed")


func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")
	print("Tutorial pressed")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")
	print("Options pressed")
