extends Node3D

class_name GunController

var guns: Array[Gun]
var current_gun: Gun
var anim_player: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# get all child guns
	var children = get_children()
	for child in children:
		if child is Gun:
			guns.append(child)
			anim_player.get_animation(child.get_name() + "_hide").track_insert_key(0, 
								anim_player.get_animation(child.get_name() + "_hide").get_length(), show_gun)


func change_gun(gun_index: int) -> void:
	#anim_player.seek(anim_player.get_animation(current_gun.get_name() + "_hide").get_length(), true)
	anim_player.stop()
	anim_player.play(current_gun.get_name() + "_hide")
	if gun_index == -1:
		gun_index = (gun_index + 1) % guns.size()
	elif gun_index == -2:
		gun_index = (gun_index - 1) % guns.size()
	
	current_gun = guns[gun_index]
	

func shoot_gun() -> void:
	if current_gun.shoot() == Enums.GunReturn.SHOOT:
		anim_player.play(current_gun.get_name() + "_shoot")
	# elif current_gun.shoot() == Enums.GunReturn.RELOAD:
	# 	anim_player.play(current_gun.get_name() + "_reload")
	

func reload_gun() -> void:
	if current_gun.reload() == Enums.GunReturn.RELOAD:
		anim_player.play(current_gun.get_name() + "_reload")
	

func show_gun() -> void:
	#anim_player.stop()
	anim_player.play(current_gun.get_name() + "_show")
