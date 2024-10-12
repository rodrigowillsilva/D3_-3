extends Node3D

class_name GunController

var guns: Array[Gun]
var current_gun: Gun
@export var anim_player: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# get all child guns
	var children = get_children()
	for child in children:
		if child is Gun:

			########################
			# Settar todas as animações para cada sinal das armas
			########################	
			
			guns.append(child)
			#anim_player.get_animation(child.get_name() + "_hide").track_insert_key(0, 
								#anim_player.get_animation(child.get_name() + "_hide").get_length(), show_gun)

func shoot_gun() -> void:
	current_gun.shoot()

func use_skill() -> void:
	current_gun.skill()

func reload_gun() -> void:
	current_gun.reload()


func change_gun(gun_index: int) -> void:
	#anim_player.seek(anim_player.get_animation(current_gun.get_name() + "_hide").get_length(), true)
	#anim_player.stop()
	#anim_player.play(current_gun.get_name() + "_hide")
	if gun_index == -1:
		gun_index = (gun_index + 1) % guns.size()
	elif gun_index == -2:
		gun_index = gun_index - 1
		if gun_index < 0:
			gun_index = guns.size() - 1


	print(guns[gun_index].get_name())
	if current_gun == guns[gun_index]:
		return

	if not current_gun == null: 
		current_gun.on_unequip()

	current_gun = guns[gun_index]
	current_gun.on_equip()
	

func show_gun() -> void:
	#anim_player.stop()
	#anim_player.play(current_gun.get_name() + "_show")
	pass
