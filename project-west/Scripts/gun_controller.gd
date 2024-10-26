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
				#anim_player.play(child.get_name() + "_shoot")
				child.anim_sprite.play("Shoot")
				child.muzzle_flash.emitting = true
			)

			child.reload_signal.connect(func() -> void:
				print(child.get_name() + &"_reload")
				#anim_player.play(child.get_name() + &"_reload")
				child.anim_sprite.play("Reload")
			)

			child.skill_signal.connect(func() -> void:
				if child is not Revolver and child is not Cross:
					#anim_player.play(child.get_name() + "_skill")
					child.anim_sprite.play("Skill")
			)
			
			child.on_unequip_signal.connect(func() -> void:
				print(child.get_name(), " a")
				anim_player.play(child.get_name() + "_hide")
				#child.anim_sprite.play("Hide")
			)
			
			

func shoot_gun() -> void:
	current_gun.shoot()

func use_skill() -> void:
	current_gun.skill()

func reload_gun() -> void:
	current_gun.reload()


func change_gun(gun_index: int) -> void:	
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
	print(animName)
	if animName.contains("_show"):
		current_gun.can_shoot = true
	elif animName.contains("_hide"):
		anim_player.play(current_gun.get_name() + "_show")

	pass
