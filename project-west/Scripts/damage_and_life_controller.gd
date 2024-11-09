extends Node3D

class_name DamageAndLifeController

var health: int = 100
var max_health: int = 100

signal die_signal
signal take_damage_signal

func take_damage(_damage_type: Enums.DamageType, damage: int) -> void:
	health -= damage
	take_damage_signal.emit()
	if health <= 0:
		die_signal.emit()
		
func heal(amount: int) -> void:
	print("Curei")
	print(health)
	health += amount
	if health > max_health:
		health = max_health

func spawn():
	health = max_health
