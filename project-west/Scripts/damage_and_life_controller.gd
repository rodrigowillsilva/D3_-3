extends Node3D

class_name DamageAndLifeController

var health: int
@export var max_health: int

signal die_signal
signal take_damage_signal

func take_damage(_damage_type: Enums.DamageType, damage: int) -> void:
	health -= damage
	take_damage_signal.emit()
	if health <= 0:
		die_signal.emit()
		
func spawn():
	health = max_health
