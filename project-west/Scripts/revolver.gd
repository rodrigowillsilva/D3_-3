extends Gun

class_name Revolver

@export var speed_boost_percent: float = 1.5
@export var hit_placeholder: Node3D

var skill_active: bool = false

func shoot() -> Enums.GunShootReturn:
	var r = super()
	if r != Enums.GunShootReturn.SHOOT:
		return r

	$GunRay.target_position = transform.basis.z * -1 * 10000
	$GunRay.force_update_transform()
	$GunRay.force_raycast_update()
	
	if $GunRay.is_colliding():
		var body = $GunRay.get_collider()
		if body != null:
			if body.has_method("take_damage"):
				body.take_damage(Enums.DamageType.BULLET, 1)
				#hit_placeholder.global_transform.origin = $GunRay.get_collision_point()
			else:
				pass
				#hit_placeholder.global_transform.origin = $GunRay.get_collision_point()
	
	return r


func skill() -> void:
	if not skill_active:
		skill_active = true
		skill_signal.emit()

func on_equip() -> void:
	super()
	skill()
	on_equip_signal.emit()

func on_unequip() -> void:
	super()
	skill_active = false
	on_unequip_signal.emit()
