extends Node3D

class_name GunController

var guns: Array[Gun]
var current_gun: Gun
@onready var anim_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# get all child guns
	anim_player.animation_finished.connect(on_end_animations)
	var children = get_children()
	for child in children:
		if child is Gun:	
			guns.append(child)
			# anim_player.get_animation(child.get_name() + "_hide").track_insert_key(1, 
			# 					anim_player.get_animation(child.get_name() + "_hide").get_length(), {"method": "show_gun", "args":[]})
			
			# set the animations to the signals
			child.shoot_signal.connect(func() -> void:
				anim_player.play(child.get_name() + "_  shoot")
			)

			child.reload_signal.connect(func() -> void:
				anim_player.play(child.get_name() + "_reload")
			)

			child.skill_signal.connect(func() -> void:
				if child is not Revolver and child is not Cross:
					print(child.get_name(), " aaa")
					anim_player.play(child.get_name() + "_skill")
			)
			
			child.on_unequip_signal.connect(func() -> void:
				anim_player.play(child.get_name() + "_hide")
			)
			
			

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

	if current_gun == guns[gun_index]:
		return

	if not current_gun == null: 
		current_gun.on_unequip()

	current_gun = guns[gun_index]
	current_gun.on_equip()
	

func show_gun() -> void:
	anim_player.play(current_gun.get_name() + "_show")
	pass

func on_end_animations(animName: StringName) -> void:
	if animName == current_gun.get_name() + "_show":
		current_gun.can_shoot = true
	elif animName == current_gun.get_name() + "_hide":
		anim_player.play(current_gun.get_name() + "_show")

	pass
