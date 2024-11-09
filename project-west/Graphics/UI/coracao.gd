extends Control

@export var vida : DamageAndLifeController
@export var progress : TextureProgressBar

func _process(delta: float) -> void:
	progress.value = vida.health
