extends Gun

class_name Cross

@export var hit_placeholder: Node3D
@export var life_regen_per_second: float = 1
@export var area_damage_scene: PackedScene

var life_regen: float = 0
var skill_active: bool = false

func _process(_delta: float) -> void:
	if skill_active:
		life_regen = life_regen_per_second * _delta
		skill_signal.emit()

func shoot() -> Enums.GunShootReturn:
	var r = super()
	if r != Enums.GunShootReturn.SHOOT:
		return r

	var dir = global_transform.basis.z * -1
	print(dir)
	var area = area_damage_scene.instantiate()
	get_tree().get_root().get_child(0).add_child(area)
	area.global_transform.origin = global_transform.origin + dir
	area.linear_velocity = dir * 50
		
	return r


func skill() -> void:
	if not skill_active:
		skill_active = true
		

func on_equip() -> void:
	super()
	skill()
	on_equip_signal.emit()

func on_unequip() -> void:
	super()
	skill_active = false
	on_unequip_signal.emit()
