extends Control

func _on_play_2_pressed() -> void:
	#get_tree().change_scene_to_file( colocar o level 1 aqui )
	pass


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
