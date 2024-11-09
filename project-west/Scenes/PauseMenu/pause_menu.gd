extends Control

@export var voltar : Button
@export var sair : Button

func _ready() -> void:
	hide()
	voltar.pressed.connect(func() -> void:
		get_tree().paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		hide()
	)
	sair.pressed.connect(func() -> void:
		get_tree().paused = false
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	)

func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel"):
		if visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			get_tree().paused = false
			hide()
		else:
			get_tree().paused = true
			show()
