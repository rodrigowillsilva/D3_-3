extends Control

@export var vida : DamageAndLifeController
@export var progress : TextureProgressBar
@export var score : SpawnController
@export var LabelScore : Label

func _process(delta: float) -> void:
	progress.value = vida.health
	LabelScore.text = "Score: " + str(score.inimigos_mortos)
